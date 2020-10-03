//
//  EnemyShipView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/30/20.
//

import SwiftUI

struct EnemyShipView:View {
    @State var isAlive:Bool = true
    var body: some View {
        if isAlive {
        Image("ufo")
            .resizable()
            .frame(width:70, height:50)
            .animation(Animation.linear(duration: 5).repeatForever(autoreverses: true))
        } else {
            EmitterView(particleCount: 200, creationPoint: UnitPoint.top, angle: Angle(degrees:360), angleRange: Angle(degrees:360), opacity: 0.5, opacityRange: 0.4, opacitySpeed: 1, scale: 0.5, scaleRange: 0.4, speed: 200, speedRange: 10, animation: Animation.linear(duration: 10))
        }
    }
}
    
    

struct EnemyShipView_Previews: PreviewProvider {
    static var previews: some View {
        EnemyShipView()
    }
}
