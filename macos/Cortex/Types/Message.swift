//
//  Message.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/31/25.
//

import SwiftUI

class Message: Identifiable {
  let id: UUID
  var backendID: UUID?
  let text: String
  let isUser: Bool
  var isPinned: Bool
  var timestamp: Date
  @Published var status: MessageStatus
  
  init(
    id: UUID = UUID(),
    backendID: UUID? = nil,
    text: String,
    isUser: Bool,
    isPinned: Bool = false,
    timestamp: Date = Date(),
    status: MessageStatus = .pending
  ) {
    self.id = id
    self.backendID = backendID
    self.text = text
    self.isUser = isUser
    self.isPinned = isPinned
    self.timestamp = timestamp
    self.status = status
  }
}
