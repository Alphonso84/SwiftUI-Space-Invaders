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
    @State private var asteroidStartLocation = CGSize(width: CGFloat.random(in: -200...200), height: -800)
    @State private var asteroidEndLocation = CGSize(width: CGFloat.random(in: -200...200), height: -800)
    @State private var upButtonPressed = false
    @State private var downButtonPressed = false
    @State private var leftButtonPressed = false
    @State private var rightButtonPressed = false
    @State private var fireButtonPressed = false
    //TODO- Use timer for some task that happens periodically.
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let timer = Timer.publish(every: 0.08, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            //MARK:- Emitter View Background Stars
            EmitterView(particleCount: 150, creationPoint: UnitPoint(x: 0.5, y: -0.1), creationRange: CGSize(width: 2, height: 0), angle: Angle(degrees: 180), scale: 0.05, scaleRange: 0.1, speed: 900, speedRange: 400, animation: Animation.linear(duration: 1).repeatForever(autoreverses: false),animationDelayThreshold: 3)
            
            VStack{
                Spacer()
                //MARK:- Ship, Asteroids, and Missile Views
                ZStack {
                    AsteroidView()
                        .offset(asteroidStartLocation.height >= -800 ? asteroidEndLocation : asteroidStartLocation)
                        .animation(.easeIn(duration: 4))
                    AsteroidView()
                        .offset(asteroidStartLocation.height >= -800 ? asteroidEndLocation : asteroidStartLocation)
                        .animation(.easeIn(duration: 8))
                    MissileView(currentLocation: missileLocation)
                        .animation(Animation.easeIn(duration: 0.2).repeatCount(2, autoreverses: false))
                        .opacity(fireButtonPressed ? 1: 0)
                        .shadow(color: .white, radius: 10, x: 0, y: 10)
                    ShipView(currentLocation:characterLocation)
                        .shadow(color:upButtonPressed ? .yellow: .blue, radius: 15, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: upButtonPressed ? 40: 20)
                        .shadow(color:upButtonPressed ? .yellow: .clear, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 25)
                        .shadow(color: .blue, radius: 6, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        .animation(.easeInOut(duration:0.08))
                        
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
                                
                            } else {
                                upButtonPressed = false
                            }
                        }
                        .onReceive(timer) { time in
                            if upButtonPressed && characterLocation.height >= -900{
                                offSet.height -= 300
                                characterLocation = offSet
                                missileLocation = offSet
                                print(characterLocation)
                                        } else {
                                            
                                            offSet.height = 0
                                            characterLocation = offSet
                                            missileLocation = offSet
                                           
                                        }
//                            offSet.height -= 100
//                            characterLocation = offSet
//                            missileLocation = offSet
//                            print(characterLocation)
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
                                    missileLocation = offSet
                                    print(characterLocation)
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
                            .offset(x: 50, y: -20)
                            .onTouchDownUpEvent(changeState: { (buttonState) in
                                if buttonState == .pressed {
                                    rightButtonPressed = true
                                    offSet.width += 100
                                    characterLocation = offSet
                                    missileLocation = offSet
                                    print(characterLocation)
                                } else {
                                    rightButtonPressed = false
                                }
                            })
                        Spacer()
                        Text("FIRE")
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(fireButtonPressed ? Color.white: Color.red).animation(.easeInOut(duration: 0.2))
                            .cornerRadius(6)
                            .padding(10)
                            .offset(x: 30, y: -20)
                            .onTouchDownUpEvent { (buttonState) in
                                if buttonState == .pressed {
                                    fireButtonPressed = true
                                    
                                    self.missileLocation.height = -1200
                                    playWeaponAudio()
                                    print(characterLocation)
                                } else {
                                    fireButtonPressed = false
                                    self.missileLocation = self.offSet
                                }
                            }
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
                                missileLocation = offSet
                                print(characterLocation)
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
    //MARK:- Position Methods
    func updatePosition() {
        
        offSet.height -= 100
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
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
