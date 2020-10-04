//
//  AsteroidView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/30/20.
//

import SwiftUI

struct AsteroidView:View {
    var asteroids = ["asteroid","asteroid-2","asteroid-3"]
    var colors = [Color.red, Color.white, Color.green, Color.yellow]
    @State var isAlive:Bool = true
    @State private var angle = Double()
    var body: some View {
        if isAlive {
            Image(asteroids.randomElement() ?? "asteroid")
            .resizable()
            .frame(width:70, height:50)
            .rotationEffect(Angle(degrees: angle))
                .animation(Animation.linear(duration:Double.random(in: 5...10)).repeatForever(autoreverses: true))
                .shadow(color:.red, radius: CGFloat(Double.random(in: 5...25)), x: 0, y: 0)
                .shadow(color: .blue, radius: 25, x: 0, y: 0)
                .animation(Animation.easeIn(duration: 5))
                .onAppear {
                    self.angle = Double.random(in: 0...360)
                }
        } else {
            EmitterView(particleCount: 200, creationPoint: UnitPoint.top, angle: Angle(degrees:360), angleRange: Angle(degrees:360), opacity: 0.5, opacityRange: 0.4, opacitySpeed: 1, scale: 0.5, scaleRange: 0.4, speed: 200, speedRange: 10, animation: Animation.linear(duration: 10))
        }
    }
}
    
    

struct AsteroidView_Previews: PreviewProvider {
    static var previews: some View {
        AsteroidView()
    }
}
