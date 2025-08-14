//
//  PromptContext.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/13/25.
//

import SwiftUI
import Combine

class PromptContext: ObservableObject {
  @Published private var prompts: [String: String] = [:] // stored drafts per chatID

  // Separate active text for each UI
  @Published var windowInputText: String = ""
  @Published var overlayInputText: String = ""
  
  @Published private var overlayChatId: String = "default" {
    didSet { commitInput(forOverlay: true, chatID: oldValue) }
  }
  @Published private var windowChatId: String = "default" {
    didSet { commitInput(forOverlay: false, chatID: oldValue) }
  }
  
  func chatId(forOverlay: Bool) -> Binding<String> {
    forOverlay
      ? Binding(get: { self.overlayChatId },
               set: { self.overlayChatId = $0 })
      : Binding(get: { self.windowChatId },
                set: { self.windowChatId = $0 })
  }
  
  func commitInput(forOverlay: Bool, chatID: String) {
    let text = forOverlay ? overlayInputText : windowInputText
    prompts[chatID] = text
  }
  
  func getPrompt(for chatID: String) -> String {
    prompts[chatID, default: ""]
  }

  func setPrompt(_ text: String, for chatID: String) {
    prompts[chatID] = text
  }
  
  func sendCurrentPrompt(forOverlay: Bool) {
    if forOverlay {
      overlayInputText = ""
    } else {
      windowInputText = ""
    }
  }
}
