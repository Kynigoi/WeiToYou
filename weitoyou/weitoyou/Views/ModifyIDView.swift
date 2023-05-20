//
//  ModifyIDView.swift
//  weitoyou
//
//  Created by Antonella Giugliano on 27/02/23.
//

import SwiftUI

struct ModifyIDView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
    }
    
    @EnvironmentObject var id: IdDevice
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @State var multipeerSession: MultipeerConnectionController?
    @State var currentView: Int = 0
    
    var body: some View {
        NavigationStack{
            
            VStack(alignment: .leading){
                Text("")
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
                } footer: {
                    Text("It is required to make your friends recognize your connection")
                    .fontWeight(.light)
                    .padding(.top)
                }
            }
            .padding(.leading, ScreenSize.width * 0.1)
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
                ToolbarItem (placement: .confirmationAction){
                    Button(action: {
                        UserDefaults.standard.set(id.IdDevice,forKey: "idDevice")
                        multipeerSession = MultipeerConnectionController(myID: id.IdDevice)
                        dismiss()
                    }, label: {
                        Text("Done")
                    })
                    .disabled(id.IdDevice.isEmpty ? true : false)
                    
                }
            }
            .navigationTitle("ID")
            .navigationBarTitleDisplayMode(.inline)
            Spacer()
        }
        
    }
}

struct ModifyIDView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyIDView().environmentObject(IdDevice())
    }
}
