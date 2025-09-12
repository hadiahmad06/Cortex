//
//  ToolbarView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/5/25.
//

import SwiftUI

struct ToolbarView: ToolbarContent {
  @EnvironmentObject var manager: ChatManager
  
  @Binding var isSidebarOpen: Bool
  
  var body: some ToolbarContent {
    ToolbarItem(placement: .navigation) {
      HStack(spacing: 4) {
        IconButton(
          systemName: "sidebar.left",
          action: {isSidebarOpen.toggle()},
          isToggled: .constant(false),
          tooltip: "Toggle Sidebar (⌘S)",
          help: "Toggle the sidebar",
          size: 32,
          fontSize: 16
        )
        IconButton(
          systemName: "square.and.pencil",
          action: {manager.windowChatID = ChatSession.draftID},
          isToggled: .constant(false),
          tooltip: "Create new chat (⌘N)",
          help: "Start a new chat",
          size: 32,
          fontSize: 16
        )
      }
      .padding(10)
    }
    ToolbarItem(placement: .principal) {
      TitleArea(manager.session(for: manager.windowChatID))
    }
    
    ToolbarItem(placement: .automatic) {
      HStack(spacing: 4) {
        //          IconButton(
        //            systemName: "square.and.arrow.up",
        //            action: OverlayWindowController.shared.toggle,
        //            isToggled: .constant(false),
        //            tooltip: "Open in overlay (⌘O)",
        //            help: "Open chat in overlay window",
        //            size: 32,
        //            fontSize: 16
        //          )
        IconButton(
          systemName: "rectangle.on.rectangle",
          action: {
            if manager.overlayChatID == manager.windowChatID {
              OverlayWindowController.shared.toggle()
            }
            manager.overlayChatID = manager.windowChatID
          },
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
