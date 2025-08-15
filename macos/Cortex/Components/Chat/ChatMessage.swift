//
//  ChatMessage.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/14/25.
//

import SwiftUI

struct ChatMessage: View {
  var msg: Message
  @State private var isHovered: Bool = false
  @State var isPinned: Bool = false
  
  var body: some View {
    VStack(alignment: msg.isUser ? .trailing : .leading, spacing: 0) {
      HStack {
        if msg.isUser {
          Spacer()
          Text(msg.text)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(.white.opacity(0.15))
            .foregroundColor(.white.opacity(0.75))
            .cornerRadius(16)
        } else {
          Text(msg.text)
            .padding(.vertical, 6)
            .foregroundColor(.white.opacity(0.75))
            .frame(maxWidth: .infinity, alignment: .leading)
          Spacer(minLength: 0)
        }
      }
      .overlay(
        Button(action: {
          isPinned.toggle()
        }) {
          Image(systemName: isPinned ? "pin.fill" : "pin")
            .font(.system(size: 12))
            .foregroundColor(.white.opacity(0.75))
            .padding(6)
            .background(Color.black.opacity(0.5))
            .clipShape(Circle())
        }
        .opacity(isHovered ? 1 : 0)
        .allowsHitTesting(isHovered)
        , alignment: msg.isUser ? .topTrailing : .topLeading
      )
      MessageFooter(msg: msg)
        .padding(.top, 4)
        .opacity(isHovered ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .allowsHitTesting(isHovered)
    }
    .padding(.horizontal, 20)
    .onHover { hovering in
      isHovered = hovering
    }
  }
}
