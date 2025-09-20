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
  
  // MARK: old function to send just the prompt, will be used when I create a backend
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
    do {
      for chunk in chunks {
        onChunk(chunk)
      }
      onComplete(promptID, responseID)
    } catch {
      onError(error)
    }
  }
  
  static func sendPromptWithContext(
//    _ newMessage: String,
    settings: AppSettings?,
    previousMessages: [Message],
    sessionID: UUID,
    onChunk: @escaping (String) -> Void,
    onComplete: @escaping (UUID, UUID) -> Void,
    onError: @escaping (Error) -> Void
  ) {
    
    
    onError(NSError(domain: "ChatAPI", code: 999, userInfo: [
      NSLocalizedDescriptionKey: "This is a spoofed test error"
    ]))
    return
    
    guard let settings = settings else {
      onError(NSError(domain: "ChatAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Settings not injected"]))
      return
    }
    
    guard let url = URL(string: "https://api.openrouter.ai/v1/chat/completions") else {
      onError(NSError(domain: "ChatAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
      return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(settings.openrouter_api_key)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    var messages: [[String: String]] = [
      ["role": "system", "content": "You are a helpful assistant."]
    ]

    for msg in previousMessages {
      messages.append([
        "role": msg.isUser ? "user" : "assistant",
        "content": msg.text
      ])
    }

//    messages.append(["role": "user", "content": newMessage])

    let payload: [String: Any] = [
      "model": "auto",
      "messages": messages,
      "stream": true
    ]

    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
    } catch {
      onError(error)
      return
    }

    let promptID = UUID()
    let responseID = UUID()

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        onError(error)
        return
      }
      guard let data = data else {
        onError(NSError(domain: "ChatAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
        return
      }

      do {
        if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
          for chunkObject in jsonArray {
            if let content = chunkObject["delta"] as? String {
              onChunk(content)
            }
          }
          onComplete(promptID, responseID)
        } else {
          onError(NSError(domain: "ChatAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"]))
        }
      } catch {
        onError(error)
      }
    }
    task.resume()
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
