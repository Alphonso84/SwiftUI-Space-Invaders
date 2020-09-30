//
//  ContentView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/28/20.
//

import SwiftUI
import AVFoundation

struct ContentView:View {
//MARK:- ContentView Properties
    @State private var laserSound: AVAudioPlayer?
    @State private var offSet = CGSize(width: 0, height: 0)
    @State private var characterLocation = CGSize(width: 0, height: 0)
    @State private var missileLocation = CGSize(width: 0, height: 0)
    var body: some View {
        ZStack {
//MARK:- Emitter View
            EmitterView(particleCount: 200, angleRange: .degrees(360), opacitySpeed: -1, scale: 0.4, scaleRange: 0.1, scaleSpeed: 0.4, speedRange: 80)
            VStack{
                HStack{
                    Text("\(self.characterLocation.debugDescription)")
                    Text("RESET").foregroundColor(.red).onTapGesture {
                        self.offSet.width = 0
                        self.offSet.height = 0
                        self.characterLocation = self.offSet
                    }
                }
                Spacer()
//MARK:- Ship and Missile Views
                ZStack {
                    ShipView(currentLocation: characterLocation)
                    
                    MissileView(currentLocation: missileLocation)
                        .animation(Animation.easeIn(duration: 0.2).repeatCount(2, autoreverses: false))
                }
//MARK:- Button Controls
                VStack {
                    Button("UP") {
                        self.upButtonPressed()
                    }
                    HStack {
                        Spacer()
                        Button("LEFT") {
                            self.leftButtonPressed()
                        }
                        Spacer()
                        Button("RIGHT") {
                            self.rightButtonPressed()
                        }
                        .offset(x: 40.0, y: 0)
                        Spacer()
                        Button("FIRE") {
                            self.fireButtonPressed { (success) in
                                if success {
                                    self.missileLocation.height -= 1300
                                    playAudio()
                                }
                            }
                        }
                        .offset(x: 30.0, y: 0)
                        .foregroundColor(.red)
                    }
                    Button("DOWN"){
                        self.downButtonPressed()
                    }
                }.offset(x: -60.0, y: /*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
//MARK:- Audio Methods
    func playAudio() {
        if let audioURL = Bundle.main.url(forResource: "ClippedAudio", withExtension: "mp3") {
            do {
                try self.laserSound = AVAudioPlayer(contentsOf: audioURL)
                self.laserSound?.numberOfLoops = 0
                self.laserSound?.play()
            } catch {
                print("Couldn't play audio Error: \(error)")
            }
        } else {
            print("No audio file found")
        }
    }
//MARK:- Button Methods
    func fireButtonPressed(completion: (_ success:Bool) ->Void) {
        withAnimation(.linear) {
            playAudio()
            self.missileLocation = self.offSet
        }
        completion(true)
    }
    func downButtonPressed(){
        offSet.height += 100
        self.characterLocation = offSet
    }
    
    func upButtonPressed(){
        offSet.height -= 100
        characterLocation = offSet
    }
    
    func rightButtonPressed(){
        offSet.width += 100
        characterLocation = offSet
    }
    
    func leftButtonPressed(){
        offSet.width -= 100
        characterLocation = offSet
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
