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
    @State private var gameMusic: AVAudioPlayer?
    @State private var offSet = CGSize(width: 0, height: 0)
    @State private var characterLocation = CGSize()
    @State private var missileLocation = CGSize(width: 0, height: 0)
    @State private var upButtonPressed = false
    @State private var downButtonPressed = false
    @State private var leftButtonPressed = false
    @State private var rightButtonPressed = false
    var body: some View {
        ZStack {
            //MARK:- Emitter View
            EmitterView(particleCount: 250, creationPoint: UnitPoint(x: 0.5, y: -0.1), creationRange: CGSize(width: 1, height: 0), angle: Angle(degrees: 180), scale: 0.02, scaleRange: 0.08, speed: 900, speedRange: 300, animation: Animation.linear(duration: 1).repeatForever(autoreverses: false),animationDelayThreshold: 3)
            
            VStack{
                Spacer()
                //MARK:- Ship and Missile Views
                ZStack {
                    EnemyShipView()
                        .offset(enemyPosition())
                    EnemyShipView()
                        .offset(enemyPosition())
                    EnemyShipView()
                        .offset(enemyPosition())
                    MissileView(currentLocation: missileLocation)
                        .animation(Animation.easeIn(duration: 0.2).repeatCount(2, autoreverses: false))
                    ShipView(currentLocation:characterLocation)
                }
                
                //MARK:- Button Controls
                VStack {
                    Text("UP")
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(upButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.3))
                        .cornerRadius(6)
                        .padding(10)
                        .onTouchDownUpEvent { (buttonState) in
                            if buttonState == .pressed {
                                upButtonPressed = true
                                offSet.height -= 100
                                characterLocation = offSet
                            } else {
                                upButtonPressed = false
                            }
                        }
                    HStack {
                        Spacer()
                        Text("LEFT")
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(leftButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.2))
                            .cornerRadius(6)
                            .padding(10)
                            .offset(x: 30, y: -20)
                            .onTouchDownUpEvent { (buttonState) in
                                if buttonState == .pressed {
                                    leftButtonPressed = true
                                    offSet.width -= 100
                                    characterLocation = offSet
                                } else {
                                    leftButtonPressed = false
                                }
                            }
                        Spacer()
                        Text("RIGHT")
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(rightButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.2))
                            .cornerRadius(6)
                            .padding(10)
                            .offset(x: 40, y: -20)
                            .onTouchDownUpEvent(changeState: { (buttonState) in
                                if buttonState == .pressed {
                                    rightButtonPressed = true
                                    offSet.width += 100
                                    characterLocation = offSet
                                } else {
                                    rightButtonPressed = false
                                }
                            })
                        Spacer()
                        Button("FIRE") {
                            self.fireButtonPressed { (success) in
                                if success {
                                    self.missileLocation.height -= 1300
                                    playWeaponAudio()
                                }
                            }
                        }
                        .buttonStyle(MyButtonStyle())
                        .offset(x: 30.0, y: 0)
                        .foregroundColor(.red)
                    }
                    Text("DOWN")
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(downButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.2))
                        .cornerRadius(6)
                        .padding(10)
                        .offset(x: 0, y: -30)
                        .onTouchDownUpEvent { (buttonState) in
                            if buttonState == .pressed {
                                downButtonPressed = true
                                offSet.height += 100
                                characterLocation = offSet
                            } else {
                                downButtonPressed = false
                            }
                        }
                }.offset(x: -60.0, y: -20.0)
            }
        } .statusBar(hidden: true)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            playMusicAudio()
        })
    }
    
    //MARK:- Enemy Position Method
    func enemyPosition() ->CGSize {
        var position = CGSize()
        let verticalPositionRange = Double.random(in: -600...(-200))
        let horizontalPositionRange = Double.random(in: -200...200)
        position = CGSize(width: horizontalPositionRange , height: verticalPositionRange)
        print("Enemy horizontal position \(position.width)")
        return position
    }
    
    //MARK:- Audio Methods
    func playMusicAudio() {
        if let audioURL = Bundle.main.url(forResource: "ES_Ultramarine - Aleph One", withExtension: "mp3") {
            do {
                try self.gameMusic = AVAudioPlayer(contentsOf: audioURL)
                self.gameMusic?.numberOfLoops = 1
                self.gameMusic?.play()
            } catch {
                print("Couldn't play audio Error: \(error)")
            }
        } else {
            print("No audio file found")
        }
    }
    
    func playWeaponAudio() {
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
            playWeaponAudio()
            self.missileLocation = self.offSet
        }
        completion(true)
    }
    func downButtonIsPressed(){
        offSet.height += 100
        self.characterLocation = offSet
    }
    
    func upButtonIsPressed(){
        offSet.height -= 100
        characterLocation = offSet
    }
    
    func rightButtonIsPressed(){
        offSet.width += 100
        characterLocation = offSet
    }
    
    func leftButtonIsPressed(){
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
