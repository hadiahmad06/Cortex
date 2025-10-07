//
//  PersistenceController.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/31/25.
//


import SwiftData

@MainActor
struct PersistenceController {
  static let shared = PersistenceController()

  let container: ModelContainer

  init(inMemory: Bool = false) {
    let schema = Schema([
      ChatSessionEntity.self,
      MessageEntity.self
    ])

    let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)

    do {
      container = try ModelContainer(for: schema, configurations: config)
    } catch {
      fatalError("Failed to initialize SwiftData container: \(error)")
    }
  }
}
