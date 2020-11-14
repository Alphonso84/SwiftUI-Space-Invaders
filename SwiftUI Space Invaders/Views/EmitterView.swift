//
//  EmitterView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/29/20.
//

import SwiftUI

struct EmitterView: View {
    private struct ParticleView:View {
        @State private var isActive = false
        let position: ParticleState<CGPoint>
        let opacity: ParticleState<Double>
        let scale: ParticleState<CGFloat>
        var body: some View {
            Image("spark")
                .frame(width:2, height: 2)
                .opacity(isActive ? opacity.end : opacity.start)
                .scaleEffect(isActive ? scale.end : scale.start)
                .position(isActive ? position.end : position.start)
                .onAppear(perform: {
                    self.isActive = true
                })
        }
    }
    
    private struct ParticleState<T> {
        var start: T
        var end: T
        
        init(_ start: T, _ end: T) {
            self.start = start
            self.end = end
        }
    }
    
    
    var images = [String]()
    var particleCount: Int
    
    var creationPoint = UnitPoint.top
    var creationRange = CGSize.zero
    
    var angle = Angle.zero
    var angleRange = Angle.zero
    
    var opacity = 1.0
    var opacityRange = 0.0
    var opacitySpeed = 0.0
    
    var scale: CGFloat = 1
    var scaleRange: CGFloat = 0
    var scaleSpeed: CGFloat = 0
    
    var speed = 50.0
    var speedRange = 10.0
    
    var animation = Animation.linear(duration: 1).repeatForever(autoreverses: false)
    var animationDelayThreshold = 0.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<self.particleCount, id:\.self) { i in
                    ParticleView(position: self.position(in: geo),opacity: self.makeOpacity(),scale: self.makeScale())
                        .animation(self.animation.delay(Double.random(in: 0...self.animationDelayThreshold)))
                }
            }
        }
    }
    
    private func position(in proxy: GeometryProxy) -> ParticleState<CGPoint> {
        let halfCreationRangeWidth = creationRange.width / 2
        let halCreationRangeHeight = creationRange.height / 2
        
        let creationOffsetX = CGFloat.random(in: -halfCreationRangeWidth...halfCreationRangeWidth)
        let creationOffsetY = CGFloat.random(in: -halCreationRangeHeight...halCreationRangeHeight)
        
        let startX = Double(proxy.size.width * (creationPoint.x + creationOffsetX))
        let startY = Double(proxy.size.height * (creationPoint.y + creationOffsetY))
        let start = CGPoint(x: startX, y: startY)
        
        let halfSpeedRange = speedRange / 2
        let actualSpeed = speed + Double.random(in: -halfSpeedRange...halfSpeedRange)
        let halfAngleRange = angleRange.radians / 2
        let actualDirection = angle.radians + Double.random(in: -halfAngleRange...halfAngleRange)
        
        let finalX = cos(actualDirection - .pi / 2) * actualSpeed
        let finalY = sin(actualDirection - .pi / 2) * actualSpeed
        let end = CGPoint(x: startX + finalX, y: startY + finalY)
        
        return ParticleState(start, end)
    }
    
    private func makeOpacity() -> ParticleState<Double> {
        let halfOpacityRange = opacityRange / 2
        let randomOpacity = Double.random(in: -halfOpacityRange...halfOpacityRange)
        return ParticleState(opacity + randomOpacity, opacity + opacitySpeed + randomOpacity)
    }
    
    private func makeScale() -> ParticleState<CGFloat> {
        let halfScaleRange = scaleRange / 2
        let randomScale = CGFloat.random(in: -halfScaleRange...halfScaleRange)
        return ParticleState(scale + randomScale, scale + scaleSpeed + randomScale)
    }
}


struct EmitterView_Previews: PreviewProvider {
    static var previews: some View {
        EmitterView(particleCount: 0)
    }
}
