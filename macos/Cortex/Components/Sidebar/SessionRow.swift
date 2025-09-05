//
//  SessionRow.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/29/25.
//

import SwiftUI

struct SessionRow: View {
  @EnvironmentObject var ctx: AppContexts
  let title: String
  let date: Date
  let id: UUID
  @State private var isHovering = false
  @ObservedObject var manager: ChatManager
  
  var body: some View {
    let isSelected = manager.windowChatID == id
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
        .fill(isSelected ? Color.gray.opacity(0.2) : (isHovering ? Color.gray.opacity(0.17) : Color.gray.opacity(0.1)))
        .animation(.easeInOut(duration: 0.1), value: isHovering)
    )
    .onHover { hovering in isHovering = hovering }
    .onTapGesture {
      ctx.chatContext.windowChatID = id
      print(id)
    }
  }
}
