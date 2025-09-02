//
//  ChatSession.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/31/25.
//

import SwiftUI
import Combine

class ChatSession: ObservableObject {
  
  // Local UUID (will sync later)
  @Published var id: UUID
  
  var createdAt: Date
  var updatedAt: Date
  
  // All messages, including finalized ones
  @Published var messages: [Message] = []

  @Published var prompt: String = ""

  // Current streaming message
  @Published var incomingMessageText: String = ""
  
  // flag indicating if a message is currently streaming
  @Published var isIncoming: Bool = false

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

  // TODO: bug where response fails to render MessageFooter and IconButton until another change is made.
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
        Task { @MainActor in
            AppContexts.ctx.chatContext.updateUUID(tempID: self.id, id: id)
        }
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
  
  // Explicit initializer to set id manually
  init(
    id: UUID,
    createdAt: Date = Date(),
    updatedAt: Date = Date(),
    messages: [Message] = []
  ) {
    self.id = id
    self.createdAt = createdAt
    self.updatedAt = updatedAt
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
