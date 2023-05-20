//
//  IdDevice.swift
//  weitoyou
//
//  Created by Antonella Giugliano on 25/02/23.
//

import Foundation
import SwiftUI

class IdDevice: ObservableObject {
    var id = UIDevice.current.name
    @Published var IdDevice: String
    init(){
        if UserDefaults.standard.string(forKey: "idDevice") == nil {
            UserDefaults.standard.set(id, forKey: "idDevice")
            IdDevice = UserDefaults.standard.string(forKey: "idDevice")!
        } else {
            IdDevice = UserDefaults.standard.string(forKey: "idDevice")!
        }
    }
}
