//
//  ChatAPI.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/16/25.
//


import Foundation

public struct ChatAPI {
  public static func initializeChatSession() {
    // Implement initialization of chat session here
    // This is a placeholder function
    print("Initializing chat session...")
    // TODO: Add API call to initialize chat session here in the future
  }
    
  static func fetchMessages(for id: UUID?) -> [Message] {
    if (id == nil) {
      return []
    } else {
      return [
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

    }
  }
}
