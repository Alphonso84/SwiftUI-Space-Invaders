//
//  ContentView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/28/20.
//

import SwiftUI

struct ContentView:View {
    @State private var offSet = CGSize(width: 0, height: 0)
    @State private var characterLocation = CGSize(width: 0, height: 0)
    @State private var missileLocation = CGSize(width: 0, height: 0)
    var body: some View {
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
                ShipView(currentLocation: offSet)
                
                MissileView(currentLocation: missileLocation)
                    .animation(.easeIn(duration: 0.2))
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
                                self.missileLocation.height -= 1000
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
    
    //MARK:- Button Methods
    
    func fireButtonPressed(completion: (_ success:Bool) ->Void) {
        withAnimation(.linear) {
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
    }
}
