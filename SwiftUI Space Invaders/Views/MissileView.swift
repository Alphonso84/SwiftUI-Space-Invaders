//
//  MissileView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/28/20.
//

import SwiftUI

struct MissileView:View {
     var currentLocation = CGSize()
     var fireLocation = CGSize()
    var body: some View {
        VStack{
            Image("bullet")
                .resizable()
                .frame(width: 10, height: 20)
                .offset(currentLocation)
                .shadow(color: .red, radius: 25, x: 0, y: -20)
                //.animation(.easeIn(duration: 1))
        }
    }
}

struct MissileView_Previews: PreviewProvider {
    static var previews: some View {
        MissileView()
    }
}
