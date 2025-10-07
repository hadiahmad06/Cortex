//
//  ChatSession.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/31/25.
//

import SwiftUI
import Combine

class ChatSession: ObservableObject {
  var chatManager: ChatManager
  
  static let draftID: UUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
  
  // Local UUID (will sync later)
  @Published var id: UUID
  
  var createdAt: Date
  var updatedAt: Date {
    didSet {
      Task { @MainActor in
        chatManager.saveSessions()
      }
    }
  }
  
  @Published var title: String
  @Published var aliases: [String]
  
  // All messages, including finalized ones
  // TODO: update on message changes rather than just array changes.
  @Published var messages: [Message] = [] {
    didSet {
      updatedAt = Date()
    }
  }

  @Published var prompt: String = ""

  // Current streaming message
  @Published var incomingMessageText: String = ""
  
  // flag indicating if a message is currently streaming
  @Published var isIncoming: Bool = false
  
  // flag indicating current chat error
  @Published var error: ChatError? = nil

  // checks if
  var isDraft: Bool {
    id == ChatSession.draftID
  }
  
  // Start streaming a new message
  func startIncomingMessage() {
    incomingMessageText = ""
    isIncoming = true
  }

  // Add a chunk to the incoming message
  func addIncomingChunk(_ chunk: String) {
    incomingMessageText += chunk
  }

  // Finalize the incoming message into messages array
  func finalizeIncomingMessage(id: UUID) {
    print("finalizing message")
    guard !incomingMessageText.isEmpty else { return }
    let message = Message(
      id: id,
      backendID: id,
      text: incomingMessageText,
      isUser: false, // or true if you’re streaming user messages
      isPinned: false,
      timestamp: Date(),
      status: .received
    )
    incomingMessageText = ""
    isIncoming = false
    messages.append(message)
  }
  
  // replaces prompt id with backend's id, and adds incoming message.
  func onComplete(localID: UUID, promptID: UUID, responseID: UUID) {
    let msg = messages.first(where: { $0.id == localID })
    msg?.backendID = promptID
    finalizeIncomingMessage(id: responseID)
  }
  
  func onError(_ error: Error) {
    // Reset streaming if no chunks received
    if self.incomingMessageText.isEmpty { isIncoming = false }

    // Coerce to NSError for domain/code inspection
    let nsError = error as NSError

    // Network / Internet / DNS issues
    if nsError.domain == NSURLErrorDomain {
      switch nsError.code {
      case NSURLErrorNotConnectedToInternet,
           NSURLErrorNetworkConnectionLost,
           NSURLErrorCannotFindHost:
        self.error = .noInternet
        return
      default:
        break
      }
    }

    // HTTP errors reported by ChatAPI
    if nsError.domain == "ChatAPI" {
      switch nsError.code {
      case 400:
        self.error = .badRequest(message: nsError.localizedDescription)
        return
      case 401:
        self.error = .badAPIKey
        return
      default:
        self.error = .unknown(message: "Server returned HTTP \(nsError.code)")
        return
      }
    }

    // Fallback for any other error (JSON parsing, unexpected errors)
    self.error = .unknown(message: nsError.localizedDescription)
  }

  // TODO: bug where response fails to render MessageFooter and IconButton until another change is made.
  @MainActor
  func sendCurrentPrompt() {
    guard !isIncoming && !prompt.isEmpty else { return }
    
    if self.isDraft {
      Task { @MainActor in
        // Promote draft session
        let newID = ChatAPI.initializeChatSession()
        chatManager.updateUUID(tempID: self.id, id: newID)
        self.id = newID
        
        // Now append and send
        appendAndSendPrompt()
      }
    } else {
      appendAndSendPrompt()
    }
  }

  // Extracted helper
  @MainActor
  private func appendAndSendPrompt() {
    startIncomingMessage()
    
    let msg = Message(
      id: UUID(),
      text: self.prompt,
      isUser: true,
      isPinned: false,
      timestamp: Date(),
      status: .pending
    )
    
    messages.append(msg)
    
    let curriedOnComplete: (UUID, UUID) -> Void = { [weak self] promptID, responseID in
      self?.onComplete(localID: msg.id, promptID: promptID, responseID: responseID)
    }
    
    ChatAPI.sendPromptWithContext(
//      self.prompt,
      settings: chatManager.settings.settings,
      previousMessages: messages,
      sessionID: self.id,
      onChunk: addIncomingChunk,
      onComplete: curriedOnComplete,
      onError: onError
    )
    
    // TODO: FIX SPINNING WHEEL OF DEATH!?!>>E<V!(UHRJC!
    DispatchQueue.main.async {
      self.prompt = ""
    }
  }
  
  // Explicit initializer to set id manually
  init(
    chatManager: ChatManager,
    id: UUID,
    createdAt: Date = Date(),
    updatedAt: Date = Date(),
    title: String = "",
    aliases: [String] = [/*"Neural Sage",
                         "Data Whisperer",
                         "Cortex Pilot",
                         "Pattern Weaver"*/],
    messages: [Message] = []
  ) {
    self.chatManager = chatManager
    self.id = id
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.title = title
    self.aliases = aliases
    self.messages = messages
  }
}

extension ChatSession: Hashable {
  static func == (lhs: ChatSession, rhs: ChatSession) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
