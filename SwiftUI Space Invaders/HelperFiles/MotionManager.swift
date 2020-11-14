//
//  MotionManager.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 10/17/20.
//

import Foundation
import Combine
import CoreMotion

class MotionManager: ObservableObject {

    private var motionManager: CMMotionManager

    @Published var x: Double = 0.0
    @Published var y: Double = 0.0
    @Published var z: Double = 0.0

    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 1/60
        self.motionManager.startAccelerometerUpdates(to: .main) { (accelerometerData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let movementData = accelerometerData {
                self.x = movementData.acceleration.x
                self.y = movementData.acceleration.y
                self.z = movementData.acceleration.z
            }
        }
    }
}
