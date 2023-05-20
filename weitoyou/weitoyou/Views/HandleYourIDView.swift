//
//  HandleYourIDView.swift
//  weitoyou
//
//  Created by Antonella Giugliano on 25/02/23.
//

import SwiftUI

extension UIApplication {
    
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}


struct HandleYourIDView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]

    }

    
    @EnvironmentObject var id: IdDevice
    @State var multipeerSession: MultipeerConnectionController?
    @State var currentView: Int = 0
    
    let insets = EdgeInsets(top: 200 , leading: 0, bottom: 10, trailing: 0)
    var body: some View {
        return Group{
            switch currentView {
            case 1:
                StartSessionView()
                    .environmentObject(multipeerSession!)
                    .navigationBarBackButtonHidden()
                    .navigationTitle("Session")
                    .navigationBarTitleDisplayMode(.large)
            default:
                HandleYourIDViewBody
            }
        }
    }
    
    var HandleYourIDViewBody: some View {
        VStack(alignment: .leading){
            Spacer()
            Text("Welcome To")
                .foregroundColor(.primary)
                .font(.title)
                .fontWeight(.bold)
            
            Text("WeiToYou")
                .foregroundColor(Color.accentColor)
                .font(.title)
                .fontWeight(.bold)
            Text("Create your ID to start connecting with your mates.It is required to make your friends recognize your connection.")
            .foregroundColor(.primary)
            .font(.subheadline)
            .fontWeight(.bold)
            .opacity(0.65)
            .kerning(0.41)
            .padding([.top,.bottom])
            //            Spacer()
            
            Section {
                TextField("Enter your ID", text: $id.IdDevice)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("button"))
                        .frame(width: ScreenSize.width * 0.85, height: ScreenSize.height * 0.06)
                        .padding(.trailing, ScreenSize.width * 0.1)
                    )
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            } header: {
                Text("Your ID:")
                    .foregroundColor(Color.accentColor)
                    .padding(.bottom)
            }
            
            Spacer()

            VStack {
                Spacer()
                Button(action: {
                    UserDefaults.standard.set(id.IdDevice,forKey: "idDevice")
                    multipeerSession = MultipeerConnectionController(myID: id.IdDevice)
                    currentView = 1
                },
                       label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 13)
                            .frame(width: ScreenSize.width * 0.85, height: ScreenSize.height * 0.06)
                            .foregroundColor(Color("button"))
                            .shadow(color: .primary.opacity(0.15), radius: 2, x: 0, y: 8
                            )
                        Text("Save")
                            .foregroundColor(Color.accentColor)
                    }
                }).disabled(id.IdDevice.isEmpty ? true : false)
                Spacer()
                    .frame(height: ScreenSize.height * 0.02)
            }
        }
        .padding(.leading)
        .navigationTitle("Your ID")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .padding(.top, ScreenSize.height * 0.1)
        .ignoresSafeArea(.keyboard, edges: .bottom)

}
}

struct HandleYourIDView_Previews: PreviewProvider {
    static var previews: some View {
        HandleYourIDView().environmentObject(IdDevice())
    }
}
