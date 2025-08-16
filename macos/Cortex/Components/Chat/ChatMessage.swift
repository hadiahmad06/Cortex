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
          Spacer()
        }
      }
    }
    .onHover { hovering in
      isHovered = hovering
    }
  }
}
