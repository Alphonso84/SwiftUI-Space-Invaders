//
//  ContentView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/28/20.
//

import SwiftUI
import AVFoundation

struct ContentView:View {
    //MARK:- Audio Properties
    @State private var laserSound: AVAudioPlayer?
    @State private var mainThrusterSound: AVAudioPlayer?
    @State private var mainThrusterShutdownSound: AVAudioPlayer?
    @State private var gameMusic: AVAudioPlayer?
    //MARK:- Location Properties
    @State private var offSet = CGSize(width: 0, height: 0)
    @State private var characterLocation = CGSize()
    @State private var missileLocation = CGSize(width: 0, height: 0)
    @State private var asteroidStartLocation = CGSize(width: CGFloat.random(in: -200...200), height: -800)
    @State private var asteroidEndLocation = CGSize(width: CGFloat.random(in: -200...200), height: 800)
    @State private var speed = 0.8
    @State private var emitterParticleCreatePoint = CGFloat(-0.1)
    //MARK:- Controll Properties
    @State private var upButtonPressed = false
    @State private var downButtonPressed = false
    @State private var leftButtonPressed = false
    @State private var rightButtonPressed = false
    @State private var fireButtonPressed = false
    //MARK:- Background Properties
    @State private var myBackGround = [.blue,Color(UIColor.blue), .black, .black]
    @State private var myBackGround2 = [.blue,.blue,Color(UIColor.blue),Color(UIColor.blue)]
    @State private var myBackGround3 = [.blue,.blue,Color(UIColor.blue),.black]
    @State var startPoint = UnitPoint(x: 0, y: 1)
    @State var endPoint = UnitPoint(x: 0, y: 0)
    //MARK:- Device Properties
    @State private var isTablet = false
    @State private var currentDevice:Device = .iPhone_11_Pro
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    ///Timer is being used in buttons to allow constantly incrementing offSet value
    let timer = Timer.publish(every: 0.09, on: .main, in: .common).autoconnect()
    var body: some View {
        
        ZStack {
            //MARK:- Emitter View Background Stars
            EmitterView(particleCount: 100, creationPoint: UnitPoint(x: 0.5, y: emitterParticleCreatePoint), creationRange: CGSize(width: 2, height: 0), angle: Angle(degrees: 180), scale: 0.05, scaleRange: 0.1, speed: 850, speedRange: 400, animation: Animation.linear(duration: 1).repeatForever(autoreverses: false),animationDelayThreshold: 3)
           // EmitterView(particleCount: 15, creationPoint: UnitPoint(x: 0.5, y: emitterParticleCreatePoint), creationRange: CGSize(width: 2, height: 0), angle: Angle(degrees: 180), scale: 0.05, scaleRange: 0.1, speed: 800, speedRange: 400, animation: Animation.linear(duration: ).repeatForever(autoreverses: false),animationDelayThreshold: 3)
            
            VStack{
                Spacer()
                //MARK:- Ship, Asteroids, and Missile Views
               
                ZStack {
//                    AsteroidView()
//                        .offset(asteroidStartLocation.height >= -200 ? asteroidEndLocation : asteroidStartLocation)
//                        .animation(.easeIn(duration: 4))
//                    AsteroidView()
//                        .offset(asteroidStartLocation.height >= -200 ? asteroidEndLocation : asteroidStartLocation)
//                        .animation(.easeIn(duration: 8))
                    MissileView(currentLocation: missileLocation)
                        .animation(Animation.easeIn(duration: 0.2).repeatCount(2, autoreverses: false))
                        .opacity(fireButtonPressed ? 1: 0)
                        .shadow(color: .white, radius: 10, x: 0, y: 10)
                    ShipView(currentLocation:characterLocation)
                        .shadow(color:upButtonPressed ? .yellow: .blue, radius: 15, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: upButtonPressed ? 40: 20)
                        .shadow(color:upButtonPressed ? .yellow: .clear, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 25)
                        .shadow(color:upButtonPressed ? .red:.clear, radius: 5, x: 0.0, y: 30)
                        .shadow(color: .blue, radius: 6, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        .animation(.easeInOut(duration:0.09))
                
                  
                }
                
                //MARK:- Button Controls
                VStack {
                    Text("UP")
                        .foregroundColor(Color.white)
                        .padding(.leading,20)
                        .padding(.trailing,20)
                        .padding(.top,10)
                        .padding(.bottom,10)
                        .background(upButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.3))
                        .cornerRadius(6)
                        
                        
                        .onTouchDownUpEvent { (buttonState) in
                            if buttonState == .pressed {
                                upButtonPressed = true
                            playThrusterAudio()
                                
                            } else {
                                upButtonPressed = false
                                withAnimation (.easeInOut(duration: 20)){
                                    self.startPoint.y = 1
                                }
                                playThrusterShutdownAudio()
                            }
                        }
                        .onReceive(timer) { time in
                            if upButtonPressed && characterLocation.height >= subtractForVerticalScreenSize(){
                                offSet.height -= 30
                               // simpleSuccess()
                                characterLocation = offSet
                                missileLocation = offSet
                                withAnimation (.easeInOut(duration: 20)){
                                    self.startPoint.y = 3
                                }
                                print(characterLocation)
                                        } else {
                                            if offSet.height < 0 {
                                            offSet.height += 3
                                                
                                            characterLocation = offSet
                                            missileLocation = offSet
                                  
                                            }
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
                            .offset(x: -10, y: -20)
                            .onTouchDownUpEvent { (buttonState) in
                                if buttonState == .pressed {
                                   leftButtonPressed = true
                                } else {
                                   leftButtonPressed = false
                                }
                            }
                            .onReceive(timer) { time in
                                if leftButtonPressed && characterLocation.width >= -deltaForHorizontalScreenSize(){
                                    offSet.width -= 20
                                   // simpleSuccess()
                                    characterLocation = offSet
                                    missileLocation = offSet
                                    print(characterLocation)
                                            } else {
                                                if offSet.width < 0 {
                                                offSet.width += 5
                                                characterLocation = offSet
                                                missileLocation = offSet
                                                }
                                            }
                                        }
                        Spacer()
                        Text("RIGHT")
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(rightButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.2))
                            .cornerRadius(6)
                            .padding(10)
                            .offset(x: 10, y: -20)
                            .onTouchDownUpEvent { (buttonState) in
                                if buttonState == .pressed {
                                    rightButtonPressed = true
                                    
                                } else {
                                    rightButtonPressed = false
                                }
                            }
                            .onReceive(timer) { time in
                                if rightButtonPressed && characterLocation.width <= deltaForHorizontalScreenSize(){
                                    offSet.width += 20
                                  //  simpleSuccess()
                                    characterLocation = offSet
                                    missileLocation = offSet
                                    print(characterLocation)
                                            } else {
                                                if offSet.width > 0 {
                                                offSet.width -= 5
                                                characterLocation = offSet
                                                missileLocation = offSet
                                                }
                                            }
                                        }
                        Spacer()
                    }
                    Text("DOWN")
                        .foregroundColor(downButtonPressed ? Color.white: Color.black)
                        .padding(10)
                        .background(downButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.2))
                        .cornerRadius(6)
                        .padding(10)
                        .offset(x: 0, y: -30)
                        .onTouchDownUpEvent { (buttonState) in
                            if buttonState == .pressed {
                                downButtonPressed = true
                            } else {
                                downButtonPressed = false
                            }
                        }
                        .onReceive(timer) { time in
                            if downButtonPressed && characterLocation.height <= 0{
                                offSet.height += 20
                               // simpleSuccess()
                                characterLocation = offSet
                                missileLocation = offSet
                                print(characterLocation)
                            }
                        }
                                    
                }
            }
        } .statusBar(hidden: true)
        .background(LinearGradient(gradient: Gradient(colors: myBackGround), startPoint: startPoint, endPoint: endPoint))
        
        .onAppear(perform: {
           //playMusicAudio()
           deviceFromScreenSize()
           print("DEVICE DETECTED: \(currentDevice)")
        })
        .edgesIgnoringSafeArea(.all)
    }
    
    //MARK:- Device Type/ Screen Size Calc
    func deviceFromScreenSize() {
        switch UIScreen.screenHeight {
        case 1366.0:
            currentDevice = .iPad_Pro_12inch
        case 1194.0:
            currentDevice = .iPad_Pro_11inch
        case 896.0:
            currentDevice = .iPhone_11_ProMax
        case 812.0:
            currentDevice = .iPhone_11_Pro
        case 736.0:
            currentDevice = .iPhone_8_Plus
        case 667.0:
            currentDevice = .iPhone_8
        default:
            currentDevice = .iPhone_11_Pro
        }
    }
    //0.6773399
    func subtractForVerticalScreenSize() ->CGFloat {
        var subtractAmount = CGFloat()
        switch currentDevice {
        case .iPad_Pro_12inch:
            subtractAmount = -1080
        case .iPad_Pro_11inch:
            subtractAmount = -908
        case .iPhone_11_ProMax:
            subtractAmount = -606
        case .iPhone_11_Pro:
            subtractAmount = -530
        case .iPhone_8_Plus:
            subtractAmount = -488
        case .iPhone_8:
            subtractAmount = -410
        default:
            subtractAmount = -530
        }
        return subtractAmount
    }
    
    func deltaForHorizontalScreenSize() ->CGFloat {
        var subtractAmount = CGFloat()
        switch currentDevice {
        case .iPad_Pro_12inch:
            subtractAmount = 440
        case .iPad_Pro_11inch:
            subtractAmount = 340
        case .iPhone_11_ProMax:
            subtractAmount = 170
        case .iPhone_11_Pro:
            subtractAmount = 160
        case .iPhone_8_Plus:
            subtractAmount = 160
        case .iPhone_8:
            subtractAmount = 160
        default:
            subtractAmount = 160
        }
        return subtractAmount
    }
    
   
    //MARK:- Audio Methods
    func playMusicAudio() {
        if let audioURL = Bundle.main.url(forResource: "ES_Ultramarine - Aleph One", withExtension: "mp3") {
            do {
                try self.gameMusic = AVAudioPlayer(contentsOf: audioURL)
                self.gameMusic?.numberOfLoops = 1
                self.gameMusic?.prepareToPlay()
                self.gameMusic?.volume = 0.3
                self.gameMusic?.play()
            } catch {
                print("Couldn't play audio Error: \(error)")
            }
        } else {
            print("No audio file found")
        }
    }
    
    func playThrusterAudio() {
        if let audioURL = Bundle.main.url(forResource: "Thruster", withExtension: "mp3") {
            do {
                try self.mainThrusterSound = AVAudioPlayer(contentsOf: audioURL)
                self.mainThrusterSound?.numberOfLoops = 1
                if upButtonPressed {
                self.mainThrusterShutdownSound?.stop()
                self.mainThrusterSound?.prepareToPlay()
                    self.mainThrusterSound?.volume = 1
                self.mainThrusterSound?.play()
                    
                } else if upButtonPressed == false {
                    self.mainThrusterSound?.stop()
                }
            } catch {
                print("Couldn't play audio Error: \(error)")
            }
        } else {
            print("No audio file found")
        }
    }
    
    func playThrusterShutdownAudio() {
        if let audioURL = Bundle.main.url(forResource: "ThrusterShutdown", withExtension: "mp3") {
            do {
                try self.mainThrusterShutdownSound = AVAudioPlayer(contentsOf: audioURL)
                self.mainThrusterShutdownSound?.numberOfLoops = 0
                self.mainThrusterSound?.stop()
                self.mainThrusterShutdownSound?.prepareToPlay()
                self.mainThrusterShutdownSound?.volume = 0.3
                self.mainThrusterShutdownSound?.play()              
               
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
