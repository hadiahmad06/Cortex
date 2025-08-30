//
//  SidebarView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/29/25.
//

import SwiftUI

struct SidebarView: View {
  @State var searchText: String = ""
  @Binding var isSidebarOpen: Bool
  
  @State var sidebarWidth: CGFloat = 350
  private let minSidebarWidth: CGFloat = 200
  private let maxSidebarWidth: CGFloat = 600
  
  var sessions: [(String, Date, UUID)]

  var body: some View {
    VStack {
      TextField("Search…", text: $searchText)
        .textFieldStyle(.roundedBorder)
        .padding(.top, 6)

      ScrollView {
        LazyVStack(alignment: .leading, spacing: 4) {
          let sortedSessions = sessions.sorted { $0.1 > $1.1 }
          ForEach(sortedSessions, id: \.2) { (title, date, id) in
            SessionRow(title: title, date: date)
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)

      SettingsButton()
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
