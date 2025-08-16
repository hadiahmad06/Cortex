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
  var isPinned: Bool
  let timestamp: Date
}

struct ChatView: View {
  @State private var hoveredMessageID: UUID?
  
  let messages: [Message] = [
    Message(
      id: UUID(),
      text: "Hello, how are you?",
      isUser: true,
      isPinned: false,
      timestamp: Date().addingTimeInterval(-300)
    ),
    Message(
      id: UUID(),
      text: "I'm good, thanks! How can I help you today?",
      isUser: false,
      isPinned: false,
      timestamp: Date().addingTimeInterval(-290)
    ),
    Message(
      id: UUID(),
      text: "Can you tell me about SwiftUI?",
      isUser: true,
      isPinned: false,
      timestamp: Date().addingTimeInterval(-280)
    ),
    Message(
      id: UUID(),
      text: "Sure! SwiftUI is a framework for building user interfaces across all Apple platforms. Do you want any other information? Please let me know blah blah blah blah blah blah blah blah blah blah blah",
      isUser: false,
      isPinned: false,
      timestamp: Date().addingTimeInterval(-270)
    ),
    Message(
      id: UUID(),
      text: "That's awesome. Thank you!",
      isUser: true,
      isPinned: false,
      timestamp: Date().addingTimeInterval(-260)
    ),
    Message(
      id: UUID(),
      text: "You're welcome! Let me know if you have more questions.",
      isUser: false,
      isPinned: false,
      timestamp: Date().addingTimeInterval(-250)
    )
  ]
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(Array(messages.enumerated()), id: \.element.id) { index, msg in
          VStack(spacing: 0) {
            if index == 0 {
              IconButtonDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
              ChatMessage(msg: msg)
                .onHover { hover in
                  hoveredMessageID = hover ? msg.id : nil
                }
            } else if index == messages.count - 1 {
              let prevMsg = messages[index - 1]
              HStack(spacing: 0) {
                if msg.isUser {
                  MessageFooterDupe(msg: prevMsg, hoveredMessageID: $hoveredMessageID)
                  IconButtonDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
                } else {
                  IconButtonDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
                  MessageFooterDupe(msg: prevMsg, hoveredMessageID: $hoveredMessageID)
                }
              }
              ChatMessage(msg: msg)
                .onHover { hover in
                  hoveredMessageID = hover ? msg.id : nil
                }
              MessageFooterDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
            } else {
              let prevMsg = messages[index - 1]
              HStack(spacing: 0) {
                if msg.isUser {
                  MessageFooterDupe(msg: prevMsg, hoveredMessageID: $hoveredMessageID)
                  IconButtonDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
                } else {
                  IconButtonDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
                  MessageFooterDupe(msg: prevMsg, hoveredMessageID: $hoveredMessageID)
                }
              }
              ChatMessage(msg: msg)
                .onHover { hover in
                  hoveredMessageID = hover ? msg.id : nil
                }
            }
          }
        }
      }
      .padding(20)
    }
  }
}

struct IconButtonDupe: View {
  let msg: Message
  @Binding var hoveredMessageID: UUID?
  
  var body: some View {
    HStack(spacing: 0) {
      if msg.isUser { Spacer() }
      IconButton(
        systemName: msg.isPinned ? "pin.fill" : "pin",
        foregroundColor: .red,
        action: {}, //{isPinned.toggle()},
        isToggled: .constant(false),
        tooltip: "",
        help: "",
        size: 28,
        fontSize: 14
      )
      .opacity(msg.isPinned ? 1 : ((msg.id == hoveredMessageID) ? 1 : 0))
      .animation(.easeInOut(duration: 0.2), value: (msg.id == hoveredMessageID))
      .allowsHitTesting((msg.id == hoveredMessageID))
      if !msg.isUser { Spacer() }
    }
    .onHover { hover in
      hoveredMessageID = hover ? msg.id : nil
    }
  }
}

struct MessageFooterDupe: View {
  let msg: Message
  @Binding var hoveredMessageID: UUID?
  
  var body: some View {
    HStack(spacing: 0) {
      if msg.isUser { Spacer() }
      MessageFooter(msg: msg)
        .opacity((msg.id == hoveredMessageID) ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: (msg.id == hoveredMessageID))
        .allowsHitTesting((msg.id == hoveredMessageID))
      if !msg.isUser { Spacer() }
    }
    .onHover { hover in
      hoveredMessageID = hover ? msg.id : nil
    }
  }
}

#Preview {
  ChatView()
}
