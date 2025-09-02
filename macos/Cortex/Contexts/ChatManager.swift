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
  private let context: ModelContext = PersistenceController.shared.container.mainContext
  @Published private var sessions: [UUID: ChatSession] = [:] {
    didSet {
      saveSessions()
    }
  }

  @Published var overlayChatID: UUID? = UUID()
  @Published var windowChatID: UUID? = UUID()

  // TODO: lazy load sessions
  init() {
    loadSessions()
  }

  func getChatSessions() -> [(String, Date, UUID)] {
    // For each session, return a tuple: (empty string, latest timestamp, UUID)
    return sessions.values.map { session in
      let latestTimestamp: Date
      if let lastMessage = session.messages.last {
        latestTimestamp = lastMessage.timestamp
      } else {
        latestTimestamp = Date()
      }
      return ("temp name", latestTimestamp, session.id)
    }
  }
  
  func session(for chatID: UUID? = nil) -> ChatSession {
    let resolvedID = chatID ?? UUID()
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
