//
//  ContentView.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 9/28/20.
//

import SwiftUI

struct ShipView:View {
    var currentLocation = CGSize()
    var body: some View {
        Image(systemName: "circle")
            .resizable()
            .frame(width:40, height:40)
            .offset(currentLocation)
            .animation(.easeOut(duration: 0.3))
    }
}
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
                        self.fireButtonPressed()
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
    
    /*
     Mark:- Each Button Method when called modifies the "offSet" State. When doing so it refreshes our view.
     */
    func fireButtonPressed(){
        self.missileLocation.height -= 1000
        
    }
    func downButtonPressed(){
        offSet.height += 100
        self.characterLocation = offSet
        self.missileLocation = characterLocation
        
    }
    
    func upButtonPressed(){
        offSet.height -= 100
        characterLocation = offSet
        missileLocation = characterLocation
    }
    
    func rightButtonPressed(){
        offSet.width += 100
        characterLocation = offSet
        missileLocation = offSet
    }
    
    func leftButtonPressed(){
        offSet.width -= 100
        characterLocation = offSet
        missileLocation = characterLocation
    }
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
