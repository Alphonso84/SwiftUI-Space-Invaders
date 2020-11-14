//
//  AnimatedGradientView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 10/8/20.
//

import SwiftUI

struct AnimatedGradientView: View {
    
    @State var gradient = [Color.blue, Color.blue, Color.purple, Color.pink, Color.orange, Color.yellow]
    @State var startPoint = UnitPoint(x: 0, y: 1)
    @State var endPoint = UnitPoint(x: 0, y: 0)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(LinearGradient(gradient: Gradient(colors: self.gradient), startPoint: self.startPoint, endPoint: self.endPoint))
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .onTapGesture {
                withAnimation (.easeInOut(duration: 10)){
                    self.startPoint = UnitPoint(x: 0, y: 0)
                    self.endPoint = UnitPoint(x: 1, y: -10)
                }
        }
            .edgesIgnoringSafeArea(.all)
    }
}

struct AnimatedGradientView2: View {
    
    @State var gradient = [Color.blue, Color.blue, Color.black, Color.black]
    @State var hueRotationValue = 0.0
    @State var saturationValue = 1.0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(LinearGradient(gradient: Gradient(colors: self.gradient), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
            .hueRotation(Angle(degrees: self.hueRotationValue))
            .saturation(self.saturationValue)
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .onTapGesture {
                withAnimation (.easeInOut(duration: 3)){
                    self.hueRotationValue = 120
                    self.saturationValue = 0.7
                }
        }
            .edgesIgnoringSafeArea(.all)
            
    }
}

struct AnimatedGradientView3: View {
    @State var value: CGFloat = 0
    @State var gradient1 = [UIColor.red, UIColor.purple]
    @State var gradient2 = [UIColor.purple, UIColor.orange]
    
    var body: some View {
        
        Circle()
            .modifier(AnimatableGradientModifier(from: self.gradient1, to: self.gradient2, interpolatedValue: self.value))
            .onTapGesture {
                withAnimation (.easeInOut(duration: 3)){
                    if (self.value<1) {
                        // animate there
                        self.value = 1
                    }
                    else {
                        // animate back
                        self.value = 0
                    }
                }
        }
    }
}

struct AnimatableGradientModifier: AnimatableModifier {
    let from: [UIColor]
    let to: [UIColor]
    var interpolatedValue: CGFloat = 0
    
    var animatableData: CGFloat {
        get { interpolatedValue }
        set { interpolatedValue = newValue }
    }
    
    func body(content: Content) -> some View {
        var gColors = [Color]()
        
        for i in 0..<from.count {
            gColors.append(colorMixer(c1: from[i], c2: to[i], interpolatedValue: interpolatedValue))
        }
        
        return RoundedRectangle(cornerRadius: 8)
            .fill(LinearGradient(gradient: Gradient(colors: gColors),
                                 startPoint: UnitPoint(x: 0, y: 0),
                                 endPoint: UnitPoint(x: 0, y: 1)))
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .edgesIgnoringSafeArea(.all)
    }
    
    func colorMixer(c1: UIColor, c2: UIColor, interpolatedValue: CGFloat) -> Color {
        guard let cc1 = c1.cgColor.components else { return Color(c1) }
        guard let cc2 = c2.cgColor.components else { return Color(c1) }
        
        // messing with interpolated value, creating waves
        let alteredValue = sin(8.5*interpolatedValue*CGFloat.pi)*0.1 + interpolatedValue
        
        // computing interpolated color channels based on the value (0..1)
        let r = cc1[0]*alteredValue + cc2[0]*(1.0 - alteredValue)
        let g = cc1[1]*alteredValue + cc2[1]*(1.0 - alteredValue)
        let b = cc1[2]*alteredValue + cc2[2]*(1.0 - alteredValue)

        return Color(red: Double(r), green: Double(g), blue: Double(b))
    }
}


struct AnimatedGradientView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedGradientView()
            .preferredColorScheme(.dark)
    }
}
