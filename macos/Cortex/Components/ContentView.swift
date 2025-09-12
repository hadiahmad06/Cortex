//
//  ContentView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import SwiftUI

struct ContentView: View {
  @State var isSidebarOpen = true
  
  var body: some View {
    HStack(spacing: 0) {
      if isSidebarOpen {
        SidebarView(isSidebarOpen: $isSidebarOpen)
      }
      VStack {
        Spacer()
        
        ChatContainer(isOverlay: false)
        
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onWindow { window in
      window.titleVisibility = .hidden
      window.titlebarAppearsTransparent = true
    }
    .toolbar {
      ToolbarView(isSidebarOpen: $isSidebarOpen)
    }
  }
}

#Preview {
    ContentView()
      .environmentObject(ChatManager())
      .environmentObject(SettingsManager())
      .environmentObject(TutorialManager())
}
