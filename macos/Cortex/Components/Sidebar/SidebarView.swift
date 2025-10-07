//
//  SidebarView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/29/25.
//

import SwiftUI

struct SidebarView: View {
//  @EnvironmentObject var chatManager: AppContexts
  @Binding var isSidebarOpen: Bool
  
  @State var sidebarWidth: CGFloat = 350
  @State var settingsWidth: CGFloat = 350
  private let minSidebarWidth: CGFloat = 200
  private let minSettingsWidth: CGFloat = 350
  private let maxSidebarWidth: CGFloat = 600
  
  @State var selectedTab: String = "history"
  
  let tabs = [
    ToggleOption(id: "history", label: "History"),
    ToggleOption(id: "settings", label: "Settings"),
  ]

  var body: some View {
    VStack {
      if(selectedTab == "history") {
        HistoryView()
      } else {
        SettingsView()
      }

      MultiToggle(
        options: tabs,
        selected: $selectedTab,
        accentColor: Color.accentColor.opacity(0.75),
        fontSize: 14,
        optionHeight: 20,
        optionWidth: 70
      )
      .padding(.horizontal, 30)
      .padding(.vertical, 12)
    }
    .padding(.horizontal, 10)
    .background(Color.black.opacity(0.10))
    .frame(maxWidth: (selectedTab == "settings" ? settingsWidth : sidebarWidth), maxHeight: .infinity)
    
    Rectangle()
      .fill(Color.clear)
      .frame(width: 4)
      .contentShape(Rectangle().inset(by: -4))
      .gesture(
        DragGesture()
          .onChanged { value in
            let newWidth = (selectedTab == "settings" ? settingsWidth : sidebarWidth) + value.translation.width
            if selectedTab == "settings" {
              if newWidth >= minSettingsWidth && newWidth <= maxSidebarWidth {
                if(newWidth + 150 < minSettingsWidth) {
                  isSidebarOpen = false
                } else {
                  isSidebarOpen = true
                }
                settingsWidth = newWidth
              }
            } else {
              if(newWidth + 150 < minSidebarWidth) {
                isSidebarOpen = false
              } else {
                isSidebarOpen = true
              }
              if newWidth >= minSidebarWidth && newWidth <= maxSidebarWidth {
                sidebarWidth = newWidth
              }
            }
            
          }
      )
      .onHover { hovering in
        if hovering {
          NSCursor.resizeLeftRight.push()
        } else {
          NSCursor.pop()
        }
      }
  }
}
