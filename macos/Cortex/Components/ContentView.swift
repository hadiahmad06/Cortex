//
//  ContentView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var tutorial: TutorialManager
  
  @State var isSidebarOpen = true
  
  var body: some View {
    ZStack {
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
//      if let _ = tutorial.nextIncompleteStep() {
//        Color.black.opacity(0.4)
        TutorialView()
//      }
    }
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
  
  let settings = SettingsManager()
  let chatManager = ChatManager(settings: settings)

  ContentView()
    .environmentObject(TutorialManager())
    .environmentObject(chatManager)
    .environmentObject(settings)
    .frame(width: 600, height: 400)
}
