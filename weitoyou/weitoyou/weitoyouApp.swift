//
//  weitoyouApp.swift
//  weitoyou
//
//  Created by Antonella Giugliano on 24/02/23.
//

import Foundation
import SwiftUI
import UIKit

struct ScreenSize {
    static var width: CGFloat = UIScreen.main.bounds.width
    static var height: CGFloat = UIScreen.main.bounds.height
}

@main
struct weitoyouApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    @StateObject var id = IdDevice()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewRouter).environmentObject(id)
        }
    }
}
