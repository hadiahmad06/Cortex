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
        VStack {
          TextField("Search in development...", text: $searchText)
            .textFieldStyle(.roundedBorder)
            .padding(.top, 6)
          ScrollView {
            LazyVStack(alignment: .leading, spacing: 4) {
              let sortedSessions = sessions.sorted { $0.1 > $1.1 }
              ForEach(sortedSessions, id: \.2) { (title, date, id) in
                HStack {
                  VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                      .font(.headline)
                      .foregroundColor(.primary)
                      .lineLimit(1)
                    Text(date, style: .date)
                      .font(.caption)
                      .foregroundColor(.secondary)
                  }
                  Spacer()
                  Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(
                  RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                )
                .padding(.vertical, 6)
                //            .hoverEffect()
              }
            }
          }
          .frame(maxWidth: 200, maxHeight: .infinity)
          HStack(spacing: 4) {
            Text("Settings")
              .font(.title3)
              .fontWeight(.bold)
            IconButton(
              systemName: "gear",
              action: {},
              isToggled: .constant(false),
              tooltip: "Settings (⌘I)",
              help: "Open settings menu",
              size: 32,
              fontSize: 16
            )
          }
          .padding(.bottom, 20)
        }
        .frame(maxWidth: 200, maxHeight: .infinity)
        .padding(.horizontal, 10)
        .background(Color.black.opacity(0.10))
        
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
