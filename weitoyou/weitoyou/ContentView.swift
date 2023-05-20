//
//  ContentView.swift
//  weitoyou
//
//  Created by Antonella Giugliano on 24/02/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var id: IdDevice
    

    @State var currentView: Int = 0
    var body: some View {
        
        //vstack
        VStack {
            if viewRouter.entryView == "introView"
            {
                IntroView()
                
            }else if viewRouter.entryView == "startSessionView" {
                
                StartSessionView()
                    .environmentObject(MultipeerConnectionController(myID: id.IdDevice))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
