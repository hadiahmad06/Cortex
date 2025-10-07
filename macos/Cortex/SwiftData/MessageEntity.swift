//
//  MessageEntity.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/31/25.
//
//

import Foundation
import SwiftData


@Model public class MessageEntity {
  @Attribute(.unique) public var id: UUID
  var text: String
  var isUser: Bool
  var isPinned: Bool
  var timestamp: Date
  var status: Int16
  @Relationship(inverse: \ChatSessionEntity.messages) var session: ChatSessionEntity?
  
  init(
    id: UUID = UUID(),
    text: String,
    isUser: Bool,
    isPinned: Bool = false,
    timestamp: Date = Date(),
    status: Int16 = 0,
    session: ChatSessionEntity? = nil
  ) {
    self.id = id
    self.text = text
    self.isUser = isUser
    self.isPinned = isPinned
    self.timestamp = timestamp
    self.status = status
    self.session = session
  }
}

extension MessageEntity {
  func toLocal() -> Message {
    return Message(
      id: self.id,
      backendID: self.id,
      text: self.text,
      isUser: self.isUser,
      isPinned: self.isPinned,
      timestamp: self.timestamp,
      status: MessageStatus(rawValue: Int(self.status)) ?? .pending
    )
  }
}

extension Message {
  func toEntity(session: ChatSessionEntity? = nil) -> MessageEntity {
    let entity = MessageEntity(
        text: self.text,
        isUser: self.isUser,
        isPinned: self.isPinned,
        status: Int16(self.status.rawValue),
        session: session
    )
    entity.id = self.backendID ?? self.id
    entity.timestamp = self.timestamp
    return entity
  }
}
