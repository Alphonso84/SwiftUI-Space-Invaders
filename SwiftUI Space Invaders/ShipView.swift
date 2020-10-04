//
//  ShipView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/28/20.
//

import SwiftUI

struct ShipView:View {
    var currentLocation = CGSize()
    var body: some View {
        Image("spaceship")
            .resizable()
            .frame(width:40, height:40)
            .offset(currentLocation)
            .animation(.easeOut(duration: 0.3))
            .shadow(color: .blue, radius: 25, x: 0, y: 0)
            .shadow(color: .yellow, radius: 15, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 20)
    }
}

struct ShipView_Previews: PreviewProvider {
    static var previews: some View {
        ShipView()
    }
}
