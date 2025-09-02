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

  // one-to-many
  @Relationship(deleteRule: .cascade) var messages: [MessageEntity] = []

  public init() {}
}

extension ChatSessionEntity {
  func toLocal() -> ChatSession {
    return ChatSession(
      id: self.id,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt,
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
    entity.messages = self.messages.map { $0.toEntity(session: entity) }
    return entity
  }
}
