//
//  LoadingSessionView.swift
//  weitoyou
//
//  Created by Antonella Giugliano on 25/02/23.
//

import SwiftUI

struct LoadingSessionView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
    }
    
    @EnvironmentObject var viewRouter: ViewRouter

    @State var isDiscardChangesPresented = false
    @Environment(\.dismiss) var dismiss: DismissAction
    @EnvironmentObject var multipeerSession: MultipeerConnectionController
    @State var currentView: Int = 0
    
    
    var body: some View {
        return Group {
            switch currentView {
            case 1:
                SendMessageView()
                    .environmentObject(multipeerSession)
            case 2:
                StartSessionView()
                    .environmentObject(multipeerSession)
            default:
                LoadingViewBody
            }
        }
    }
    var LoadingViewBody: some View {
        NavigationStack {
            ZStack{
                VStack{
                    Spacer()
                    Image("ballofwollstart")
                        .resizable()
                        .scaledToFit()
                        .frame(height: ScreenSize.height / 7)
                        .position(x: ScreenSize.width/2, y: ScreenSize.height/3)
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
                            multipeerSession.session.disconnect()
                            multipeerSession.isRequestAccepted = false
                            
                            currentView = 2
                            if (viewRouter.entryView == "startSessionView") {
                                dismiss()
                            }
                        }
                        
                        Button("Cancel", role: .cancel) {isDiscardChangesPresented = false}
                    }
                    
                    Spacer()
                        .frame(height: ScreenSize.height * 0.02)
                }
                Text("tying the red thread of fate")
                    .textCase(.lowercase)
                    .font(.title3)
                    .kerning(0.41)
                    .lineSpacing(28)
                    .multilineTextAlignment(.center)
                    .fontWeight(.light)
                    .opacity(0.65)
                    .frame(width: ScreenSize.width / 1.5 )
                    .position(x: ScreenSize.width/2, y: ScreenSize.height/2)
            }
            .navigationBarBackButtonHidden()
            .onChange(of: multipeerSession.isRequestAccepted, perform: { newValue in
                    currentView = 1
            })
            .onChange(of: multipeerSession.isRequestDeclined == true, perform: {
                newValue in
                currentView = 2
            })
        }
        
        
    }
}

struct LoadingSessionView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSessionView().environmentObject(MultipeerConnectionController(myID: "test"))
    }
}
