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
        Image(systemName: "chevron.compact.up")
            .resizable()
            .frame(width: 10, height: 10)
            .offset(currentLocation)
    }
}

struct MissileView_Previews: PreviewProvider {
    static var previews: some View {
        MissileView()
    }
}
