//
//  EnemyShipView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/30/20.
//

import SwiftUI

struct EnemyShipView:View {
    var body: some View {
        Image("ufo")
            .resizable()
            .frame(width:70, height:50)
            .animation(Animation.linear(duration: 4).repeatForever(autoreverses: true))
    }
}
    
    

struct EnemyShipView_Previews: PreviewProvider {
    static var previews: some View {
        EnemyShipView()
    }
}
