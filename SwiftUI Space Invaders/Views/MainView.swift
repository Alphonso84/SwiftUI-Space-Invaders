//
//  ContentView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/28/20.
//

import SwiftUI
import CoreMotion
import AVFoundation

struct MainView:View {
    //MARK:- ModelProperties
    @ObservedObject var motion: MotionManager
    @State private var audioModel = AudioModel()
    @State private var locationModel = LocationModel()
    @State private var controlModel = ControlModel()
    //MARK:- Background Properties
    @State private var myBackGround = [Color(UIColor.blue),Color(UIColor.blue),Color(UIColor.blue),.blue, .black, .black, .black]
    @State private var myBackGround2 = [.blue,.blue,Color(UIColor.blue),Color(UIColor.blue)]
    @State private var myBackGround3 = [.blue,.blue,Color(UIColor.blue),.black]
    @State var startPoint = UnitPoint(x: 0, y: 0.01)
    @State var endPoint = UnitPoint(x: 0, y: 0)
    //MARK:- Device Properties
    @State private var isTablet = false
    @State private var currentDevice:Device = .iPhone_11_Pro
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    //MARK:- Body
    ///Timer is being used in buttons to allow constantly incrementing offSet value
    let timer = Timer.publish(every: 0.10, on: .main, in: .common).autoconnect()
    var body: some View {
        
        ZStack {
            EmitterView(particleCount: 250, creationPoint: UnitPoint(x: 0.5, y: -0.1), creationRange: CGSize(width: 1, height: 0), angle: Angle(degrees: 180), scale: 0.02, scaleRange: 0.08, speed: 900, speedRange: 300, animation: Animation.linear(duration: 0.75).repeatForever(autoreverses: false),animationDelayThreshold: 10)
            
            VStack{
                Spacer()
                //MARK:- Ship, Asteroids, and Missile Views
                ZStack {
                    MissileView(currentLocation:locationModel.missileLocation, fireLocation: locationModel.missileLocation)
                        .opacity(controlModel.fireButtonPressed ? 1 : 0)
                        .animation(.easeInOut(duration:0.2))
                        .shadow(color: .white, radius: 6, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        .animation(.easeInOut(duration:0.09))
                        .rotationEffect(.degrees(controlModel.leftButtonPressed ? -5: 0))
                        .animation(.easeInOut(duration:1))
                        .rotationEffect(.degrees(controlModel.rightButtonPressed ? +5: 0))
                        .animation(.easeInOut(duration:1))
                        .onAppear(perform: {
                            withAnimation(.easeIn(duration:10)){
                                locationModel.opacity = 20
                            }
                        })
                    
                    ShipView(currentLocation:locationModel.characterLocation)
                        .opacity(locationModel.opacity)
                        .shadow(color:controlModel.upButtonPressed ? .yellow: .blue, radius: 15, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: controlModel.upButtonPressed ? 40: 20)
                        .shadow(color:controlModel.upButtonPressed ? .yellow: .clear, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 25)
                        .shadow(color:controlModel.upButtonPressed ? .red:.clear, radius: 5, x: 0.0, y: 30)
                        .animation(.easeInOut(duration:0.2))
                        .shadow(color: .white, radius: 6, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        .animation(.easeInOut(duration:0.09))
                        .rotationEffect(.degrees(controlModel.leftButtonPressed ? -5: 0))
                        .animation(.easeInOut(duration:1))
                        .rotationEffect(.degrees(controlModel.rightButtonPressed ? +5: 0))
                        .animation(.easeInOut(duration:1))
                        .onAppear(perform: {
                            withAnimation(.easeIn(duration:10)){
                                locationModel.opacity = 20
                            }
                        })
                }
                //MARK:- Button Controls
                HStack {
                    VStack {
                        Text("UP")
                            .foregroundColor(Color.white)
                            .padding(.leading,20)
                            .padding(.trailing,20)
                            .padding(.top,10)
                            .padding(.bottom,10)
                            .frame(width:70, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(controlModel.upButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.01))
                            .cornerRadius(6)
                            .offset(x: 5, y: -5)
                            .onTouchDownUpEvent { (buttonState) in
                                if buttonState == .pressed {
                                    controlModel.upButtonPressed = true
                                    playThrusterAudio()
                                } else {
                                    controlModel.upButtonPressed = false
                                    playThrusterAudio()
                                    playThrusterShutdownAudio()
                                }
                            }
                            .onReceive(timer) { time in
                                if controlModel.upButtonPressed && locationModel.characterLocation.height >= subtractForVerticalScreenSize(){
                                    locationModel.offSet.height -= 40
                                    locationModel.characterLocation = locationModel.offSet
                                    locationModel.missileLocation = locationModel.characterLocation
                                } else {
                                    if locationModel.offSet.height < 0 {
                                        locationModel.offSet.height += 10
                                        locationModel.characterLocation = locationModel.offSet
                                        locationModel.missileLocation = locationModel.characterLocation
                                    }
                                }
                            }
                        HStack {
                            Spacer()
                            Text("LEFT")
                                .foregroundColor(Color.white)
                                .padding(10)
                                .frame(width:70, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .background(controlModel.leftButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.2))
                                .cornerRadius(6)
                                .padding(10)
                                .offset(x: 0, y: -20)
                                .onTouchDownUpEvent { (buttonState) in
                                    if buttonState == .pressed {
                                        controlModel.leftButtonPressed = true
                                    } else {
                                        controlModel.leftButtonPressed = false
                                    }
                                }
                                .onReceive(timer) { time in
                                    if controlModel.leftButtonPressed && locationModel.characterLocation.width >= -deltaForHorizontalScreenSize(){
                                        locationModel.offSet.width -= 60
                                        locationModel.characterLocation = locationModel.offSet
                                        locationModel.missileLocation = locationModel.characterLocation
                                        print(locationModel.characterLocation)
                                    } else {
                                        //DO SOMETHING WHEN BUTTON IS RELEASED
                                        locationModel.turningDegrees = 0
                                    }
                                }
                            Spacer()
                            Text("RIGHT")
                                .foregroundColor(Color.white)
                                .padding(10)
                                .background(controlModel.rightButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.2))
                                .cornerRadius(6)
                                .padding(10)
                                //.frame(width:70, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .offset(x: 10, y: -20)
                                .onTouchDownUpEvent { (buttonState) in
                                    if buttonState == .pressed {
                                        controlModel.rightButtonPressed = true
                                        
                                    } else {
                                        controlModel.rightButtonPressed = false
                                    }
                                }
                                .onReceive(timer) { time in
                                    if controlModel.rightButtonPressed && locationModel.characterLocation.width <= deltaForHorizontalScreenSize(){
                                        locationModel.offSet.width += 60
                                        locationModel.characterLocation = locationModel.offSet
                                        locationModel.missileLocation = locationModel.characterLocation
                                        print(locationModel.characterLocation)
                                    } else {
                                        //DO SOMETHING WHEN BUTTON IS RELEASED
                                        locationModel.turningDegrees = 0
                                    }
                                }
                            Spacer()
                        }
                        Text("DOWN")
                            .foregroundColor(controlModel.downButtonPressed ? Color.white: Color.white)
                            .padding(10)
                            .background(controlModel.downButtonPressed ? Color.white: Color.blue).animation(.easeInOut(duration: 0.2))
                            .cornerRadius(6)
                            .padding(10)
                            //.frame(width:70, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .offset(x: 5, y: -30)
                            .onTouchDownUpEvent { (buttonState) in
                                if buttonState == .pressed {
                                    controlModel.downButtonPressed = true
                                } else {
                                    controlModel.downButtonPressed = false
                                }
                            }
                            .onReceive(timer) { time in
                                if controlModel.downButtonPressed && locationModel.characterLocation.height <= 0{
                                    locationModel.characterLocation = locationModel.offSet
                                    locationModel.missileLocation = locationModel.characterLocation
                                    print(locationModel.characterLocation)
                                }
                            }
                       
                    }
                    .offset(x: -50, y: 0)
                    Text("FIRE")
                                               .foregroundColor(Color.white)
                                               .padding(10)
                                               .background(controlModel.fireButtonPressed ? Color.white: Color.red).animation(.easeInOut(duration: 0.2))
                                               .cornerRadius(6)
                                               .padding(10)
                                               .offset(x: -30, y: -29)
                                               .onTouchDownUpEvent { (buttonState) in
                                                   if buttonState == .pressed {
                                                       controlModel.fireButtonPressed = true
                                                       
                                                       locationModel.missileLocation.height = -1200
                                                       playWeaponAudio()
                                                       
                                                   } else {
                                                       controlModel.fireButtonPressed = false
                                                       locationModel.missileLocation = locationModel.characterLocation
                                                   }
                                               }
                }
            }
            
        }
        .statusBar(hidden: true)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
           playMusicAudio()
           deviceFromScreenSize()
            print(UIScreen.screenHeight)
           print("DEVICE DETECTED: \(currentDevice)")
        })
        
    }
    
    //MARK:- Device Type/ Screen Size Calc
    func deviceFromScreenSize() {
        switch UIScreen.screenHeight {
        case 1366.0:
            currentDevice = .iPad_Pro_12inch
        case 1194.0:
            currentDevice = .iPad_Pro_11inch
        case 1024.0:
            currentDevice = .iPad_Standard
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

    func subtractForVerticalScreenSize() ->CGFloat {
        var subtractAmount = CGFloat()
        switch currentDevice {
        case .iPad_Pro_12inch:
            subtractAmount = -1080
        case .iPad_Pro_11inch:
            subtractAmount = -908
        case .iPad_Standard:
            subtractAmount = -800
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
        case .iPad_Standard:
            subtractAmount = 320
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
                try self.audioModel.gameMusic = AVAudioPlayer(contentsOf: audioURL)
                self.audioModel.gameMusic?.numberOfLoops = 1
                self.audioModel.gameMusic?.prepareToPlay()
                self.audioModel.gameMusic?.volume = 0.3
                self.audioModel.gameMusic?.play()
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
                try self.audioModel.mainThrusterSound = AVAudioPlayer(contentsOf: audioURL)
                self.audioModel.mainThrusterSound?.numberOfLoops = 1
                if controlModel.upButtonPressed {
                    self.audioModel.mainThrusterShutdownSound?.stop()
                    self.audioModel.mainThrusterSound?.prepareToPlay()
                    self.audioModel.mainThrusterSound?.volume = 1
                    self.audioModel.mainThrusterSound?.play()
                    
                } else if controlModel.upButtonPressed == false {
                    self.audioModel.mainThrusterSound?.stop()
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
                try self.audioModel.mainThrusterShutdownSound = AVAudioPlayer(contentsOf: audioURL)
                self.audioModel.mainThrusterShutdownSound?.numberOfLoops = 0
                self.audioModel.mainThrusterSound?.stop()
                self.audioModel.mainThrusterShutdownSound?.prepareToPlay()
                self.audioModel.mainThrusterShutdownSound?.volume = 0.3
                self.audioModel.mainThrusterShutdownSound?.play()
               
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
                try self.audioModel.laserSound = AVAudioPlayer(contentsOf: audioURL)
                self.audioModel.laserSound?.numberOfLoops = 0
                self.audioModel.laserSound?.play()
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
        MainView(motion: MotionManager())
            .preferredColorScheme(.dark)
    }
}
