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
           // EmitterView(particleCount: 1000, angleRange: .degrees(90), opacitySpeed: 1, scale: 0.05, scaleRange: 0.01, scaleSpeed: 0.2, speedRange: 20000)
              //  .offset(CGSize(width:00, height:-200))
                
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
                    EnemyShipView()
                        .offset(enemyPosition())
                    EnemyShipView()
                        .offset(enemyPosition())
                    EnemyShipView()
                        .offset(enemyPosition())
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
    
 //MARK:- Enemy Position Method
    func enemyPosition() ->CGSize {
        var position = CGSize()
        let verticalPositionRange = Double.random(in: -600...(-200))
        let horizontalPositionRange = Double.random(in: -200...200)
        position = CGSize(width: horizontalPositionRange , height: verticalPositionRange)
        print(position.debugDescription)
        return position
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
