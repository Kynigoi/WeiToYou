//
//  StartSessionView.swift
//  weitoyou
//
//  Created by Antonella Giugliano on 24/02/23.
//

import SwiftUI
import MultipeerConnectivity
import os

struct StartSessionView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
    }
    
    
    @EnvironmentObject var multipeerSession: MultipeerConnectionController
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var currentView: Int = 0
    @State var isModifyIDShowing = false
    @State  var selectedPeerID = ""
    @State  var isSelected = false
    @State var  selectedPeer: MCPeerID? = nil
    
    var body: some View {
        return Group{
            switch currentView {
            case 1:
                LoadingSessionView()
                    .environmentObject(multipeerSession)
            case 2:
                SendMessageView()
            default:
                StartSessionViewBody
            }
        }
    }
    var StartSessionViewBody: some View {
        NavigationStack{
            VStack{
                
                Text("Connect your thread")
                    .font(.title)
                    .kerning(0.41)
                    .lineSpacing(28)
                    .opacity(0.65)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Spacer()
                Image("ballofwollstart")
                    .resizable()
                    .scaledToFit()
                    .frame(height: ScreenSize.height / 6.4)
                
                Spacer()
                
                VStack(){
                    if (!multipeerSession.isRequestAccepted){
                        List {
                            Section("Active Peers to tie with") {
                                ForEach(multipeerSession.availablePeers, id: \.self) { peer in
                                    Button(peer.displayName) {
                                        if selectedPeerID == peer.displayName {
                                            selectedPeerID = ""
                                            isSelected = false
                                            selectedPeer = nil
                                        }
                                        else if selectedPeerID == "" {
                                            self.selectedPeerID = peer.displayName
                                            isSelected = true
                                            selectedPeer = peer
                                        }
                                        else if selectedPeerID != "" && selectedPeerID != peer.displayName {
                                            self.selectedPeerID = peer.displayName
                                            isSelected = true
                                            selectedPeer = peer
                                        }
                                        
                                    }.listRowBackground(self.selectedPeerID == peer.displayName ? Color.accentColor : Color("listItemColor"))
                                    .foregroundColor(.black)                                }
                            }
                            .headerProminence(.increased)
                            .alert("\(multipeerSession.peerRequesting?.displayName ?? "ERR") wants to connect with you. Do you want to accept?", isPresented: $multipeerSession.request) {
                                
                                Button("Decline", role: .destructive) {
                                    if (multipeerSession.invitationHandler != nil) {
                                        multipeerSession.invitationHandler!(false, nil)
                                        multipeerSession.isRequestAccepted = false
                                        multipeerSession.isRequestDeclined = true
                                        multipeerSession.session.disconnect()
                                        
                                    }
                                }
                                Button("Accept", role: .cancel) {
                                    if (multipeerSession.invitationHandler != nil) {
                                        multipeerSession.invitationHandler!(true, multipeerSession.session)
                                        multipeerSession.isRequestAccepted = true
                                        multipeerSession.isRequestDeclined = false
                                    }
                                }
                            }
                            
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .frame(height: ScreenSize.height/3.2)
                    }
                    
                    Button(action: {
                        if let peer = selectedPeer{
                            multipeerSession.serviceBrowser.invitePeer(peer, to: multipeerSession.session, withContext: nil, timeout: 10)
                            currentView = 1
                        }
                    },
                           label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: ScreenSize.width * 0.8, height: ScreenSize.height * 0.06)
                                .foregroundColor(Color("button"))
                                .shadow(color: .primary.opacity(0.2), radius: isSelected ? 8 : 0, x: 0, y: 4
                                )
                            Text("Start")
                                .foregroundColor(Color.accentColor)
                        }
                    }).disabled(!isSelected)
                    Spacer()
                        .frame(height: ScreenSize.height * 0.02)
                }
                .navigationTitle(viewRouter.entryView == "startSessionView" ? "Session" : "")
                
                .sheet(isPresented: $isModifyIDShowing) {
                    ModifyIDView()
                        .interactiveDismissDisabled()
                        .scrollDismissesKeyboard(.interactively)
                }
                .onChange(of: multipeerSession.isRequestAccepted == true, perform: {
                    newValue in currentView = 2
                })
            }.navigationBarTitleDisplayMode(.large)
                .navigationBarBackButtonHidden()
                .toolbar{
                    ToolbarItem(placement: .primaryAction){
                        Button {
                            isModifyIDShowing.toggle()
                        } label: {
                            if(viewRouter.entryView == "startSessionView") {Image(systemName: "person.circle")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 30, height: 30)
                            }
                        }
                    }
                }
        }
        .toolbar{
            ToolbarItem(placement: .primaryAction){
                Button {
                    isModifyIDShowing.toggle()
                } label: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                    
                }
            }
        }
    }
    
    struct StartSessionView_Previews: PreviewProvider {
        static var previews: some View {
            StartSessionView().environmentObject(MultipeerConnectionController(myID: "test")).environmentObject(ViewRouter())
        }
    }
}
