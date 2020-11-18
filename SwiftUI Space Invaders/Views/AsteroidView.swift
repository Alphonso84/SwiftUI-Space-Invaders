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
    var isAlive = true
    @State var currentLocation = CGSize()
    @State private var angle = Double()
    var body: some View {
        if isAlive {
            Image(asteroids.randomElement() ?? "asteroid")
                .resizable()
                .frame(width:70, height:50)
                .offset(currentLocation)
                .animation(.easeIn(duration:34))
                //.rotationEffect(Angle(degrees: angle))
                .shadow(color:.red, radius: CGFloat(Double.random(in: 5...25)), x: 0, y: 0)
                .shadow(color: .blue, radius: 25, x: 0, y: 0)
                .onAppear {
                    self.angle = Double.random(in: 1...360)
                }
        } else {
            EmitterView(particleCount: 200, creationPoint: UnitPoint.center, angle: Angle(degrees:360), angleRange: Angle(degrees:360), opacity: 0.5, opacityRange: 0.8, opacitySpeed: 1, scale: 0.5, scaleRange: 0.4, speed: 800, speedRange: 300, animation: Animation.easeInOut(duration: 10))
        }
    }
}
    
    

struct AsteroidView_Previews: PreviewProvider {
    static var previews: some View {
        AsteroidView()
    }
}
