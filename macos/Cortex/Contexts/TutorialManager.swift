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
  var welcome: Bool = false
  var hasAddedKey: Bool = false
  var knowsLimits: Bool = false
  var knowsChatBasics: Bool = false
  var knowsModelSwitching: Bool = false
}

// MARK: - TutorialManager
class TutorialManager: ObservableObject {
    
  @Published var state = TutorialState()
  @Published var currentStep: TutorialStep? = nil
  
  private var cancellables = Set<AnyCancellable>()
  private let key = "tutorial_state"
  
  init() {
    load()
    observeChanges()
    updateCurrent()
  }
  
  private func updateCurrent() {
    self.currentStep = nextIncompleteStep()
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
    updateCurrent()
  }
  
  func nextIncompleteStep() -> TutorialStep? {
    if !state.welcome { return .welcome }
    if !state.hasAddedKey { return .addKey }
    if !state.knowsLimits { return .limits }
    if !state.knowsChatBasics { return .chatBasics }
    if !state.knowsModelSwitching { return .modelSwitching }
    return nil
  }
  
  func complete(step: TutorialStep) {
//    print("completed")
    switch step {
    case .welcome: state.welcome = true
    case .addKey: state.hasAddedKey = true
    case .limits: state.knowsLimits = true
    case .chatBasics: state.knowsChatBasics = true
    case .modelSwitching: state.knowsModelSwitching = true
    }
    updateCurrent()
  }
}

// MARK: - Tutorial Steps Enum
enum TutorialStep: String, CaseIterable {
  case welcome
  case addKey
  case chatBasics
  case modelSwitching
  case limits
  
//  var description: String {
//    switch self {
//    case .addKey: return "Add your API key to start chatting."
//    case .chatBasics: return "Learn how to send messages in the chat UI."
//    case .modelSwitching: return "Learn how to switch between models/providers."
//    case .limits: return "Understand usage limits and token costs."
//    }
//  }
}
