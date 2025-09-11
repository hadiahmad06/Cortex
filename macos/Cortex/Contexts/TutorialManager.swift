//
//  TutorialManager.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/11/25.
//

import SwiftUI
import Combine

// MARK: - Codable Struct for Tutorial State
struct TutorialState: Codable {
  var hasAddedKey: Bool = false
  var knowsChatBasics: Bool = false
  var knowsModelSwitching: Bool = false
  var knowsLimits: Bool = false
  var knowsClearingChats: Bool = false
}

// MARK: - TutorialManager
class TutorialManager: ObservableObject {
    
  @Published var state = TutorialState() // all tutorial flags in one struct
  
  private var cancellables = Set<AnyCancellable>()
  private let key = "tutorial_state"
  
  private init() {
    load()
    observeChanges()
  }
  
  // MARK: - Observe Changes Using Combine
  private func observeChanges() {
    $state
      .dropFirst() // ignore initial value
      .sink { [weak self] _ in
        self?.save()
      }
      .store(in: &cancellables)
  }
  
  // MARK: - Persistence
  private func save() {
    if let data = try? JSONEncoder().encode(state) {
      UserDefaults.standard.set(data, forKey: key)
    }
  }
  
  private func load() {
    guard let data = UserDefaults.standard.data(forKey: key),
      let saved = try? JSONDecoder().decode(TutorialState.self, from: data)
    else { return }
    self.state = saved
  }
  
  // MARK: - Helper Methods
  
  func resetTutorials() {
    state = TutorialState()
  }
  
  func nextIncompleteStep() -> TutorialStep? {
    if !state.hasAddedKey { return .addKey }
    if !state.knowsChatBasics { return .chatBasics }
    if !state.knowsModelSwitching { return .modelSwitching }
    if !state.knowsLimits { return .limits }
    if !state.knowsClearingChats { return .clearingChats }
    return nil
  }
  
  func complete(step: TutorialStep) {
    switch step {
    case .addKey: state.hasAddedKey = true
    case .chatBasics: state.knowsChatBasics = true
    case .modelSwitching: state.knowsModelSwitching = true
    case .limits: state.knowsLimits = true
    case .clearingChats: state.knowsClearingChats = true
    }
  }
}

// MARK: - Tutorial Steps Enum
enum TutorialStep: String, CaseIterable {
  case addKey
  case chatBasics
  case modelSwitching
  case limits
  case clearingChats
  
  var description: String {
    switch self {
    case .addKey: return "Add your API key to start chatting."
    case .chatBasics: return "Learn how to send messages in the chat UI."
    case .modelSwitching: return "Learn how to switch between models/providers."
    case .limits: return "Understand usage limits and token costs."
    case .clearingChats: return "Learn how to clear chats and reset context."
    }
  }
}
