//
//  ChatSessionContext.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/16/25.
//

import SwiftUI
import Combine
import SwiftData

@MainActor
class ChatManager: ObservableObject {
  static let fallbackHeaderTexts: [String] = [
    "New Chat",
    "Fresh Convo",
    "Still Thinking...",
    "Thinking...",
    "Untitled Chat",
    "Response Incoming..."
  ]
  
  private let context: ModelContext = PersistenceController.shared.container.mainContext
  
  @Published private var sessions: [UUID: ChatSession] = [:] {
    didSet {
      saveSessions()
      updateSummaries()
    }
  }
  @Published private(set) var sessionSummaries: [(String, Date, UUID)] = []

  @Published var overlayChatID: UUID = ChatSession.draftID
  @Published var windowChatID: UUID = ChatSession.draftID

  // TODO: lazy load sessions
  init() {
    loadSessions()
  }

  private func updateSummaries() {
    sessionSummaries = sessions.values.compactMap { session in
      guard !session.isDraft else { return nil }
      let latestTimestamp = session.messages.last?.timestamp ?? Date()
      let headerText = session.title.isEmpty
        ? (session.aliases.last ?? ChatManager.fallbackHeaderTexts.randomElement()!)
        : session.title
      return (headerText, latestTimestamp, session.id)
    }
  }
  
  func session(for chatID: UUID = ChatSession.draftID) -> ChatSession {
    let resolvedID = chatID
    if let existingSession = sessions[resolvedID] {
      return existingSession
    } else {
      let newSession = ChatSession(id: resolvedID)
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
      let newSession = ChatSession(id: id)
      sessions[id] = newSession
    }
  }
}


extension ChatManager {
  func loadSessions() {
    do {
      let descriptor = FetchDescriptor<ChatSessionEntity>()
      let entities = try context.fetch(descriptor)
      for entity in entities {
        let session = entity.toLocal()
        sessions[session.id] = session
      }
    } catch {
      print("Failed to fetch sessions: \(error)")
    }
  }

  func saveSessions() {
    do {
      for session in sessions.values {
        let entity = session.toEntity()
        context.insert(entity)
      }
      try context.save()
    } catch {
      print("Failed to save sessions: \(error)")
    }
  }
}

extension ChatManager {
  func clearAllSessions() {
    sessions.removeAll()
     overlayChatID = ChatSession.draftID
     windowChatID = ChatSession.draftID
    do {
      let fetchDescriptor = FetchDescriptor<ChatSessionEntity>()
      let entities = try self.context.fetch(fetchDescriptor)
      for entity in entities {
        self.context.delete(entity)
      }
      try self.context.save()
    } catch {
      print("Failed to clear stored sessions: \(error)")
    }
  }
}


