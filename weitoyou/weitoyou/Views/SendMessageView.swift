//
//  SendMessageView.swift
//  weitoyou
//
//  Created by Walter Galiano on 27/02/23.
//

import SwiftUI

struct SendMessageView: View {
    @State private var message: String = ""
    @EnvironmentObject var multipeerSession: MultipeerConnectionController
    
    @State var currentView: Int = 0
    @State var isDiscardChangesPresented = false
    @Environment(\.dismiss) var dismiss: DismissAction
    
    var body: some View {
        switch currentView {
        case 1:
            StartSessionView()
                .environmentObject(multipeerSession)
        
        default:
            SendMessageViewBody
        }
    }
    
    var SendMessageViewBody: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Send a message to your peer!")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)
                TextField("Message", text: $message)
                    .padding([.horizontal], 75.0)
                    .padding(.bottom, 24)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)

                Button("Continue →") {
                    multipeerSession.send(message: message)

                }.buttonStyle(BorderlessButtonStyle())
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(12)
                //.disabled(username.isEmpty ? true : false)
                Spacer()
                
                Text(multipeerSession.receivedMessage)
                
                Spacer()
                
                
                Button(action: {
                    isDiscardChangesPresented.toggle()
                },
                       label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 13)
                            .frame(width: ScreenSize.width * 0.8, height: ScreenSize.height * 0.06)
                            .foregroundColor(Color("button"))
                            .shadow(color: .primary.opacity(0.15), radius: 2, x: 0, y: 8
                            )
                        Text("Stop")
                            .foregroundColor(Color.accentColor)
                    }
                }).confirmationDialog("Are you sure you want to stop this session?",
                                      isPresented: $isDiscardChangesPresented,
                                      titleVisibility: .visible) {
                    Button("Stop", role: .destructive) {
//                        multipeerSession.session.cancelConnectPeer(multipeerSession.session.connectedPeers[0])
                        multipeerSession.session.disconnect()
                        multipeerSession.isRequestAccepted = false
                        currentView = 1
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {isDiscardChangesPresented = false}
                }
                
                Spacer()
                    .frame(height: ScreenSize.height * 0.02)

            }
            .onChange(of: multipeerSession.isRequestAccepted == false , perform: {
                newValue in
                currentView = 1 })
            
            .navigationTitle("Messages")
            .navigationBarBackButtonHidden()
            
        }
        .onTapGesture(perform: {
                    self.endTextEditing()
                })
    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

struct SendMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SendMessageView().environmentObject(MultipeerConnectionController(myID: "test"))
    }
}
