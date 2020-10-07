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
            .animation(.easeOut(duration: 2))
    }
}

struct ShipView_Previews: PreviewProvider {
    static var previews: some View {
        ShipView()
    }
}
