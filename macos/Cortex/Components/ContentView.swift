//
//  ContentView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import SwiftUI

struct ContentView: View {
  @State var isSidebarOpen = true
  
  @EnvironmentObject var ctx: AppContexts
  
  var body: some View {
    HStack(spacing: 0) {
      if isSidebarOpen {
        SidebarView(isSidebarOpen: $isSidebarOpen)
      }
      VStack {
        Spacer()
        
        ChatContainer(isOverlay: false)
//        PromptBox(isOverlay: false)
        
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onWindow { window in
      window.titleVisibility = .hidden
      window.titlebarAppearsTransparent = true
    }
    .toolbar {
      ToolbarView(
        manager: ctx.chatContext,
        isSidebarOpen: $isSidebarOpen
      )
    }
  }
}

#Preview {
    ContentView()
    .environmentObject(AppContexts.ctx)
}
