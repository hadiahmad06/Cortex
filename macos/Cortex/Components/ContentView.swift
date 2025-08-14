//
//  ContentView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      HStack {
        Spacer()
        
        
        IconButton(
          systemName: "rectangle.on.rectangle",
          action: OverlayWindowController.shared.toggle,
          isToggled: .constant(false),
          tooltip: "Open in overlay (⌘O)",
          help: "Open chat in overlay window",
          size: 32,
          fontSize: 16
        )
      }
//      .background(Color.black.opacity(0.1))
      .transition(.opacity)
      .zIndex(1)
      
    
      Spacer()
      
      PromptBox()
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
    ContentView()
    .environmentObject(AppContexts())
}
