//
//  ChatMessage.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/14/25.
//

import SwiftUI

struct ChatMessage: View {
  var msg: Message
  
  var body: some View {
    
    VStack(alignment: msg.isUser ? .trailing : .leading, spacing: 0) {
      HStack {
        if msg.isUser { Spacer() }
        let (segments, isInlineOnly) = MarkdownRenderer.render(self.msg.text)
        VStack(alignment: .leading, spacing: 0) {
          ForEach(0..<segments.count, id: \.self) { i in
            segments[i]
              .padding(.horizontal, (msg.isUser && isInlineOnly) ? 12 : 0)
              .background((msg.isUser && isInlineOnly) ? .white.opacity(0.15) : .clear)
          }
        }
        .padding(.horizontal, (msg.isUser && !isInlineOnly) ? 12 : 0)
        .background((msg.isUser && !isInlineOnly) ? .white.opacity(0.15) : .clear)
        .cornerRadius(msg.isUser ? 16 : 0)
        .frame(maxWidth: msg.isUser ? 600 : .infinity, alignment: msg.isUser ? .trailing : .leading)
        if !msg.isUser { Spacer() }
      }
    }
  }
}
