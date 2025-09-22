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
    // _ newMessage: String,
    settings: AppSettings?,
    previousMessages: [Message],
    sessionID: UUID,
    onChunk: @escaping (String) -> Void,
    onComplete: @escaping (UUID, UUID) -> Void,
    onError: @escaping (Error) -> Void
  ) {
    
    guard let settings = settings else {
      onError(NSError(domain: "ChatAPI", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "API Key not injected, retry in a minute"
      ]))
      return
    }

    guard let url = URL(string: "https://openrouter.ai/api/v1/chat/completions") else {
      onError(NSError(domain: "ChatAPI", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Invalid URL"
      ]))
      return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(settings.openrouter_api_key)", forHTTPHeaderField: "Authorization")
    request.addValue("https://mirag.app", forHTTPHeaderField: "HTTP-Referrer")
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

    let payload: [String: Any] = [
      "model": "mistralai/mistral-medium-3",
      "messages": messages,
      "stream": true
    ]

    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: payload)
    } catch {
      onError(NSError(domain: "ChatAPI", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Failed to encode JSON payload"
      ]))
      return
    }

    let promptID = UUID()
    let responseID = UUID()

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      // Network errors — pass as-is
      if let error = error {
        onError(error)
        return
      }

      // HTTP errors — create an Error because URLSession does not throw
      if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
        let httpError = NSError(
          domain: "ChatAPI",
          code: httpResponse.statusCode,
          userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)]
        )
        onError(httpError)
        return
      }

      // No data
      guard let data = data else {
        onError(NSError(domain: "ChatAPI", code: 0, userInfo: [
          NSLocalizedDescriptionKey: "No data returned from server."
        ]))
        return
      }

      // JSON parsing errors — pass as-is
      Task {
          do {
              let (stream, response) = try await URLSession.shared.bytes(for: request)

              guard let httpResponse = response as? HTTPURLResponse,
                    (200..<300).contains(httpResponse.statusCode) else {
                  let code = (response as? HTTPURLResponse)?.statusCode ?? 0
                  onError(NSError(domain: "ChatAPI", code: code, userInfo: [
                      NSLocalizedDescriptionKey: "Server returned HTTP \(code)"
                  ]))
                  return
              }

              var buffer = Data()

              for try await byte in stream {
                  buffer.append(byte)

                  // Attempt to parse each complete "data: {...}" chunk immediately
                  while true {
                      guard let range = buffer.range(of: "data: ".data(using: .utf8)!) else { break }
                      let chunkStart = range.upperBound

                      // Find the next newline after "data: "
                      guard let newlineRange = buffer[chunkStart...].firstRange(of: "\n".data(using: .utf8)!) else { break }
                      let chunkData = buffer[chunkStart..<newlineRange.lowerBound]
                      buffer.removeSubrange(buffer.startIndex..<newlineRange.upperBound)

                      // Skip keep-alive signals or empty data
                      if chunkData.isEmpty { continue }
                      if let lineStr = String(data: chunkData, encoding: .utf8),
                         lineStr != "[DONE]",
                         let jsonObject = try? JSONSerialization.jsonObject(with: Data(lineStr.utf8)) as? [String: Any],
                         let choices = jsonObject["choices"] as? [[String: Any]] {

                          for choice in choices {
                              if let delta = choice["delta"] as? [String: Any],
                                 let content = delta["content"] as? String {
                                  await MainActor.run {
                                      onChunk(content) // send chunk immediately
                                  }
                              }
                          }
                      }
                  }
              }

              // Finished streaming
              await MainActor.run {
                  onComplete(promptID, responseID)
              }

          } catch {
              await MainActor.run {
                  onError(error)
              }
          }
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
