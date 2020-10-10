//
//  Helper.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 10/7/20.
//

import Foundation
import SwiftUI

enum Device {
    case iPad_Pro_12inch
    case iPad_Pro_11inch
    case iPad_Standard
    case iPhone_11_ProMax
    case iPhone_11_Pro
    case iPhone_8_Plus
    case iPhone_8
    case iPhone_SE
}


extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
