//
//  ChatAPI.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/16/25.
//


import Foundation

public struct ChatAPI {
  public static func initializeChatSession() -> UUID {
    // Implement initialization of chat session here
    // This is a placeholder function
    print("Initializing chat session...")
    // TODO: Add API call to initialize chat session here in the future
    return UUID()
  }
  
  static func sendPrompt(
    _ prompt: String,
    sessionID: UUID,
    onChunk: @escaping (String) -> Void,
    onComplete: @escaping (UUID, UUID) -> Void,
    onError: @escaping (Error) -> Void
  ) {
    // Mock streaming: break prompt into "chunks", reverse or repeat as dummy content
    let promptID = UUID()
    let responseID = UUID()
    let response = "Hello! This is a mock AI response."
    let chunks = [
      String(response.prefix(10)),
      String(response.dropFirst(10).prefix(10)),
      String(response.dropFirst(20))
    ]
    // Simulate possible error
    do {
      // 10% chance to throw an error
//      if Int.random(in: 1...10) == 1 {
//        struct MockError: Error {}
//        throw MockError()
//      }
      for chunk in chunks {
        onChunk(chunk)
        // Simulate delay (not actually async, but could be)
      }
      onComplete(promptID, responseID)
    } catch {
      onError(error)
    }
  }
    
  static func fetchMessages(for id: UUID?) -> [Message] {
    return []
    if (id == nil) {
      return []
    } else {
      return [
        Message(
          id: UUID(),
          text: "old response here",
          isUser: false,
          isPinned: false,
          timestamp: Date().addingTimeInterval(-300),
          status: .delivered
        )
      ]
      return [
          Message(
            id: UUID(),
            text: "Hello, how are you?",
            isUser: true,
            isPinned: false,
            timestamp: Date().addingTimeInterval(-300),
            status: .delivered
          ),
          Message(
            id: UUID(),
            text: "I'm good, thanks! How can I help you today?",
            isUser: false,
            isPinned: false,
            timestamp: Date().addingTimeInterval(-290),
            status: .received
          ),
          Message(
            id: UUID(),
            text: "Hello, how are you?",
            isUser: true,
            isPinned: false,
            timestamp: Date().addingTimeInterval(-300),
            status: .delivered
          ),
          Message(
            id: UUID(),
            text: "I'm good, thanks! How can I help you today?",
            isUser: false,
            isPinned: false,
            timestamp: Date().addingTimeInterval(-290),
            status: .received
          ),
          Message(
            id: UUID(),
            text: "Can you tell me about SwiftUI?",
            isUser: true,
            isPinned: false,
            timestamp: Date().addingTimeInterval(-280),
            status: .delivered
          ),
          Message(
            id: UUID(),
            text: "Sure! SwiftUI is a framework for building user interfaces across all Apple platforms. Do you want any other information? Please let me know blah blah blah blah blah blah blah blah blah blah blah",
            isUser: false,
            isPinned: false,
            timestamp: Date().addingTimeInterval(-270),
            status: .received
          ),
          Message(
            id: UUID(),
            text: "That's awesome. Thank you!",
            isUser: true,
            isPinned: false,
            timestamp: Date().addingTimeInterval(-260),
            status: .delivered
          ),
          Message(
            id: UUID(),
            text: "You're welcome! Let me know if you have more questions.",
            isUser: false,
            isPinned: false,
            timestamp: Date().addingTimeInterval(-250),
            status: .received
          )
        ]

    }
  }
}
