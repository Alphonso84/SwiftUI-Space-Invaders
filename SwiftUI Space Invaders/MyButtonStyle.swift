//
//  MyButtonStyle.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 10/1/20.
//

import SwiftUI

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 60, height: 25)
            .foregroundColor(.white)
            .background(configuration.isPressed ?Color.white: .blue)
            .cornerRadius(10)
    }
}

