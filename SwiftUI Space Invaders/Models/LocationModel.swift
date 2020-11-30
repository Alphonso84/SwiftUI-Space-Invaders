//
//  LocationModel.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 11/14/20.
//

import Foundation
import SwiftUI

struct LocationModel {
    var offSet = CGSize(width: 0, height: 0)
    var characterLocation = CGSize()
    var missileLocation = CGSize(width: 0, height: 0)
    var asteroidStartLocation = CGSize(width: CGFloat.random(in: -180...180), height: -800)
    var asteroidEndLocation = CGSize(width: CGFloat.random(in: -180...180), height: 800)
    var speed = 850.0
    var turningDegrees = Double()
    var opacity = 0.0
    var AsteroidAlive = true
    var emitterParticleCreatePoint = CGFloat(-0.1)
}
