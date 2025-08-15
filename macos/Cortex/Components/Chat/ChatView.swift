//
//  ChatView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/14/25.
//

import SwiftUI

struct Message: Identifiable {
  let id: UUID
  let text: String
  let isUser: Bool
//  var isPinned: Bool
  let timestamp: Date
}

struct ChatView: View {
  let messages: [Message] = [
    Message(
      id: UUID(),
      text: "Hello, how are you?",
      isUser: true,
      // isPinned: false,
      timestamp: Date().addingTimeInterval(-300)
    ),
    Message(
      id: UUID(),
      text: "I'm good, thanks! How can I help you today?",
      isUser: false,
      // isPinned: false,
      timestamp: Date().addingTimeInterval(-290)
    ),
    Message(
      id: UUID(),
      text: "Can you tell me about SwiftUI?",
      isUser: true,
      // isPinned: false,
      timestamp: Date().addingTimeInterval(-280)
    ),
    Message(
      id: UUID(),
      text: "Sure! SwiftUI is a framework for building user interfaces across all Apple platforms.",
      isUser: false,
      // isPinned: false,
      timestamp: Date().addingTimeInterval(-270)
    ),
    Message(
      id: UUID(),
      text: "That's awesome. Thank you!",
      isUser: true,
      // isPinned: false,
      timestamp: Date().addingTimeInterval(-260)
    ),
    Message(
      id: UUID(),
      text: "You're welcome! Let me know if you have more questions.",
      isUser: false,
      // isPinned: false,
      timestamp: Date().addingTimeInterval(-250)
    )
  ]
  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(messages) { msg in
          ChatMessage(msg: msg)
        }
      }
    }
  }
}

#Preview {
  ChatView()
}
