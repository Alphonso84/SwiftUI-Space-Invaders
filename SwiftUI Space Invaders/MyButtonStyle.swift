//
//  MyButtonStyle.swift
//  SwiftUI Space Invaders
//
//  Created by Alphonso Sensley II on 10/1/20.
//

import SwiftUI

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 60, height: 25)
            .foregroundColor(.white)
            .background(configuration.isPressed ?Color.white: .blue)
            .cornerRadius(10)
    }
}

public enum ButtonState {
    case pressed
    case notPressed
}

/// ViewModifier allows us to get a view, then modify it and return it
public struct TouchDownUpEventModifier: ViewModifier {
    /// Properties marked with `@GestureState` automatically resets when the gesture ends/is cancelled
    /// for example, once the finger lifts up, this will reset to false
    /// this functionality is handled inside the `.updating` modifier
    @GestureState private var isPressed = false
    
    /// this is the closure that will get passed around.
    /// we will update the ButtonState every time your finger touches down or up.
    let changeState: (ButtonState) -> Void
    
    /// a required function for ViewModifier.
    /// content is the body content of the caller view
    public func body(content: Content) -> some View {
        
        /// declare the drag gesture
        let drag = DragGesture(minimumDistance: 0)
            
            /// this is called whenever the gesture is happening
            /// because we do this on a `DragGesture`, this is called when the finger is down
            .updating($isPressed) { (value, gestureState, transaction) in
                
            /// setting the gestureState will automatically set `$isPressed`
            gestureState = true
        }
        
        return content
        .gesture(drag) /// add the gesture
        .onChange(of: isPressed, perform: { (pressed) in /// call `changeState` whenever the state changes
            /// `onChange` is available in iOS 14 and higher.
            if pressed {
                self.changeState(.pressed)
            } else {
                self.changeState(.notPressed)
            }
        })
    }
}
