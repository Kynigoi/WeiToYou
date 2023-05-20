//
//  MultipeerConnection.swift
//  weitoyou
//
//  Created by Antonella Giugliano on 25/02/23.
//

import Foundation
import MultipeerConnectivity
import os

class MultipeerConnectionController: NSObject, ObservableObject {
    let serviceType = "weitoyou-srvc"
    private var myPeerID: MCPeerID
    public let serviceAdvertiser: MCNearbyServiceAdvertiser
    public let serviceBrowser: MCNearbyServiceBrowser
    public let session: MCSession
    @Published var receivedMessage: String = ""
    @Published var availablePeers: [MCPeerID] = []
    @Published var request: Bool = false
    @Published var peerRequesting: MCPeerID? = nil
    @Published var isRequestAccepted: Bool = false
    @Published var isRequestDeclined: Bool = false
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    private let logger = Logger()
    init(myID: String) {
        var peerID = MCPeerID(displayName: myID)
        self.myPeerID = peerID
        
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
        
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
        
        
    }
    
    
    func stopSession(){
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
        
        session.delegate = nil
        serviceAdvertiser.delegate = nil
        serviceBrowser.delegate = nil
    }
    
    func send(message: String) {
        if !session.connectedPeers.isEmpty {
            logger.info("sendMove: \(message) to \(self.session.connectedPeers[0].displayName)")
            do {
                try session.send(message.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                logger.error("Error sending: \(String(describing: error))")
            }
        }
    }
    
}

extension MultipeerConnectionController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        logger.error("didNotStartAdvertisingPeer - ServiceAdvertiser StartAdvertisingPeer Failed: \(String(describing: error))")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        logger.info("didReceiveInvitationFromPeer - InvitationFromPeer \(peerID)")
        
        DispatchQueue.main.async {
            // show alert for request to pair
            self.request = true
            // peerID sending the request
            self.peerRequesting = peerID
            // handle the request
            self.invitationHandler = invitationHandler
        }
    }
}

extension MultipeerConnectionController: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        logger.error("didNotStartBrowsingForPeers - ServiceBroser StartBrowsingForPeers Failed: \(String(describing: error))")
    }
    
    // Add found peer to available peers list
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        logger.info("foundPeer - ServiceBrowser found peer: \(peerID)")
        DispatchQueue.main.async {
            self.availablePeers.append(peerID)
        }
    }
    
    // Delete lost peer from available peers list
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        logger.info("lostPeer - ServiceBrowser lost peer: \(peerID)")
        DispatchQueue.main.async {
            self.availablePeers.removeAll(where: {
                $0 == peerID
            })
        }
    }
}

extension MultipeerConnectionController: MCSessionDelegate {
    // Handle session change of state
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        logger.info("peer \(peerID) didChangeState: \(state.rawValue)")
        switch state {
            // Peer disconnected
        case MCSessionState.notConnected:
            DispatchQueue.main.async {
                self.isRequestAccepted = false
                self.isRequestDeclined = true
            }
            // Start advertising after unpairing with a peer
            serviceAdvertiser.startAdvertisingPeer()
            break
            // Peer connected
        case MCSessionState.connected:
            DispatchQueue.main.async {
                self.isRequestAccepted = true
                self.isRequestDeclined = false
            }
            // Stop advertising after pairing with a peer
            serviceAdvertiser.stopAdvertisingPeer()
            break
            // Default state, waiting for a connection
        default:
            DispatchQueue.main.async {
                self.isRequestAccepted = false
                self.isRequestDeclined = false
            }
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
            logger.info("didReceive message \(data)")
            DispatchQueue.main.async {
                self.receivedMessage = message
            }
        }
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        logger.error("InputStream")
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        logger.error("didStartReceivingResourceWithName")
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        logger.error("didFinishReceivingResourceWithName")
    }
    
    public func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
}

