////
////  PromptContext.swift
////  Cortex
////
////  Created by Hadi Ahmad on 8/13/25.
////
//
//import SwiftUI
//import Combine
//
//class PromptContext: ObservableObject {
//  @Published var prompt: String = "" // stored draft
//  
//  func sendCurrentPrompt(forOverlay: Bool) {
//    ChatAPI.sendPrompt(prompt)
//    prompt = ""
//  }
//}
//
//class PromptManager: ObservableObject {
//  @Published private var contexts: [UUID: PromptContext] = [:]
//
//  func getContext(for id: UUID) -> PromptContext {
//    if let context = contexts[id] {
//      return context
//    } else {
//      let newContext = PromptContext()
//      contexts[id] = newContext
//      return newContext
//    }
//  }
//
//  func removeContext(for id: UUID) {
//    contexts.removeValue(forKey: id)
//  }
//}
