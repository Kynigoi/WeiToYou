//
//  ViewRouter.swift
//  weitoyou
//
//  Created by Antonella Giugliano on 24/02/23.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject{
    @Published var entryView: String
    init(){
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore"){
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            entryView = "introView"
        } else {
            entryView = "startSessionView"
        }
    }
}
