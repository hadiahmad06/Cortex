//
//  SidebarView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/29/25.
//

import SwiftUI

struct SidebarView: View {
  @EnvironmentObject var ctx: AppContexts
  @Binding var isSidebarOpen: Bool
  
  @State var sidebarWidth: CGFloat = 350
  private let minSidebarWidth: CGFloat = 200
  private let maxSidebarWidth: CGFloat = 600
  
  @ObservedObject var manager: ChatManager
  
  @State var selectedTab: String = "history"
  
  let tabs = [
    ToggleOption(id: "history", label: "History"),
    ToggleOption(id: "settings", label: "Settings"),
  ]

  var body: some View {
    VStack {
      if(selectedTab == "history") {
        HistoryView(manager: manager)
      } else {
        VStack {
          
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }

      MultiToggle(
        options: tabs,
        selected: $selectedTab,
        accentColor: Color.accentColor.opacity(0.75)
      )
        .padding(.bottom, 8)
    }
    .padding(.horizontal, 10)
    .background(Color.black.opacity(0.10))
    .frame(maxWidth: sidebarWidth, maxHeight: .infinity)
    
    Rectangle()
      .fill(Color.clear)
      .frame(width: 4)
      .contentShape(Rectangle().inset(by: -4))
      .gesture(
        DragGesture()
          .onChanged { value in
            let newWidth = sidebarWidth + value.translation.width
            if(newWidth + 150 < minSidebarWidth) {
              isSidebarOpen = false
            } else {
              isSidebarOpen = true
            }
            if newWidth >= minSidebarWidth && newWidth <= maxSidebarWidth {
              sidebarWidth = newWidth
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
