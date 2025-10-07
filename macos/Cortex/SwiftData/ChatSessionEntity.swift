//
//  ChatSessionEntity.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/31/25.
//
//

import Foundation
import SwiftData

@Model
public class ChatSessionEntity {
  @Attribute(.unique) public var id: UUID = UUID()
  var createdAt: Date = Date()
  var updatedAt: Date = Date()
  var title: String = ""
  var aliases: [String] = []

  // one-to-many
  @Relationship(deleteRule: .cascade) var messages: [MessageEntity] = []

  public init() {}
}

extension ChatSessionEntity {
  @MainActor func toLocal(chatManager: ChatManager) -> ChatSession {
    return ChatSession(
      chatManager: chatManager,
      id: self.id,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt,
      title: self.title,
      aliases: self.aliases,
      messages: self.messages.map { $0.toLocal() } // map each MessageEntity
    )
  }
}

extension ChatSession {
  func toEntity() -> ChatSessionEntity {
    let entity = ChatSessionEntity()
    entity.id = self.id
    entity.createdAt = self.createdAt
    entity.updatedAt = self.updatedAt
    entity.title = self.title
    entity.aliases = self.aliases
    entity.messages = self.messages.map { $0.toEntity(session: entity) }
    return entity
  }
}
