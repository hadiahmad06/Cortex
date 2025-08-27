//
//  ChatSessionContext.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/16/25.
//

import SwiftUI
import Combine

class ChatSessionContext: ObservableObject {
  
  // Local UUID (will sync later)
  @Published var id: UUID

  @Published var prompt: String = ""

  // All messages, including finalized ones
  @Published var messages: [Message] = []

  // Current streaming message
  @Published var incomingMessageText: String = ""
  
  // flag indicating if a message is currently streaming
  @Published var isIncoming: Bool = false

  // Append a finalized message
//  func appendMessage(_ message: Message) {
//    startIncomingMessage()
//    messages.append(message)
//  }

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
  
  func onComplete(localID: UUID, promptID: UUID, responseID: UUID) {
    let msg = messages.first(where: { $0.id == localID })
    msg?.backendID = promptID
    finalizeIncomingMessage(id: responseID)
  }

  func sendCurrentPrompt() {
    if(!isIncoming && prompt != "") {
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
      if messages.isEmpty {
        AppContexts.ctx.chatContext.updateUUID(tempID: self.id, id: id)
      }
      let curriedOnComplete: (UUID, UUID) -> Void = { [weak self] promptID, responseID in
          self?.onComplete(localID: msg.id, promptID: promptID, responseID: responseID)
      }
      ChatAPI.sendPrompt(
        self.prompt,
        sessionID: self.id,
        onChunk: addIncomingChunk,
        onComplete: curriedOnComplete,
        onError: {_ in } // will add later
      )
      self.prompt = ""
    }
  }

  // Optional: clear all messages
//    func clearMessages() {
//        messages.removeAll()
//        incomingMessageText = ""
//        isIncoming = false
//    }

  // Explicit initializer to set id manually
  init(id: UUID) {
    self.id = id
  }
}

extension ChatSessionContext: Hashable {
  static func == (lhs: ChatSessionContext, rhs: ChatSessionContext) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

class ChatManager: ObservableObject {
  @Published private var sessions: [UUID: ChatSessionContext] = [:]

  @Published var overlayChatID: UUID? = UUID()
  @Published var windowChatID: UUID? = nil

  func session(for chatID: UUID? = nil) -> ChatSessionContext {
    let resolvedID = chatID ?? UUID()
    if let existingSession = sessions[resolvedID] {
      return existingSession
    } else {
      let newSession = ChatSessionContext(id: resolvedID)
      sessions[resolvedID] = newSession
      return newSession
    }
  }
  
  func updateUUID(tempID: UUID, id: UUID) {
    if let existingSession = sessions[tempID] {
      // updates temp id
      existingSession.id = id
      sessions.removeValue(forKey: tempID)
      sessions[id] = existingSession
      if(overlayChatID == tempID) {
        overlayChatID = id
      }
      if(windowChatID == tempID) {
        windowChatID = id
      }
    } else {
      // creates new (from fetch usually)
      let newSession = ChatSessionContext(id: id)
      sessions[id] = newSession
    }
  }
}
