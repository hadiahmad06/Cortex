//
//  ContentView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import SwiftUI

struct ContentView: View {
  @State var isSidebarOpen = true
  @State var searchText = ""
  
  @EnvironmentObject var ctx: AppContexts
  
  var body: some View {
    let sessions = ctx.chatContext.getChatSessions()
    HStack {
      if isSidebarOpen {
        SidebarView(sessions: sessions)
      }
      VStack {
        Spacer()
        
        ChatView(isOverlay: false)
        PromptBox(isOverlay: false)
        
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onWindow { window in
      window.titleVisibility = .hidden
      window.titlebarAppearsTransparent = true
    }
    .toolbar {
      ToolbarItem(placement: .navigation) {
        HStack(spacing: 4) {
          IconButton(
            systemName: "sidebar.left",
            action: OverlayWindowController.shared.toggle,
            isToggled: .constant(false),
            tooltip: "Open in overlay (⌘O)",
            help: "Open chat in overlay window",
            size: 32,
            fontSize: 16
          )
          IconButton(
            systemName: "square.and.pencil",
            action: OverlayWindowController.shared.toggle,
            isToggled: .constant(false),
            tooltip: "Open in overlay (⌘O)",
            help: "Open chat in overlay window",
            size: 32,
            fontSize: 16
          )
        }
        .padding(10)
      }
      ToolbarItem(placement: .principal) {
        Text("temporary chat name")
      }

      ToolbarItem(placement: .automatic) {
        HStack(spacing: 4) {
          IconButton(
            systemName: "square.and.arrow.up",
            action: OverlayWindowController.shared.toggle,
            isToggled: .constant(false),
            tooltip: "Open in overlay (⌘O)",
            help: "Open chat in overlay window",
            size: 32,
            fontSize: 16
          )
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
        .padding(10)
      }
    }
  }
}

#Preview {
    ContentView()
    .environmentObject(AppContexts.ctx)
}
