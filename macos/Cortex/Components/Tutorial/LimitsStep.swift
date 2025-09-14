//
//  LimitsStep.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/12/25.
//

import SwiftUI

struct LimitsStep: View, TutorialStepView {
  @ObservedObject var settings: SettingsManager
  
  // MARK: - TutorialStepView conformance
  var step: TutorialStep = .limits
  
  func nextValidation() -> Bool {
    // Example: require at least 1 history item and a nonzero request limit
    if settings.settings.chatHistoryLength > 0 && settings.settings.requestLimit > 0 && settings.settings.maxTokensPerRequest > 0 && settings.settings.dailyTokenCap > 0{
      return true
    }
    return false
  }
  
  func skipValidation() -> Bool {
      // Skipping just means accept defaults
      return true
  }
  
  var erased: AnyView { AnyView(self) }
  
  // MARK: - View body
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Set API Usage Limits")
        .font(.title)
        .fontWeight(.bold)
      
      Text("Configure how many messages are stored and how many requests per session are allowed.")
        .foregroundColor(.secondary)
        .fixedSize(horizontal: false, vertical: true)

      // Chat history length
      Stepper(
        "Chat history length: \(settings.settings.chatHistoryLength) messages",
        value: $settings.settings.chatHistoryLength,
        in: 1...200
      )
      
      // Request limit
      Stepper(
        "Request limit: \(settings.settings.requestLimit) requests",
        value: $settings.settings.requestLimit,
        in: 10...1000,
        step: 10
      )

      // Max tokens per request
      Stepper(
        "Max tokens per request: \(settings.settings.maxTokensPerRequest)",
        value: $settings.settings.maxTokensPerRequest,
        in: 100...32000,
        step: 100
      )

      // Daily token cap
      Stepper(
        "Daily token cap: \(settings.settings.dailyTokenCap)",
        value: $settings.settings.dailyTokenCap,
        in: 1000...500000,
        step: 1000
      )
      

      // Toggle for override
      Toggle(
        "Allow token cap override",
        isOn: $settings.settings.allowTokenCapOverride
      )
      
      Text("You can change these settings later in Preferences.")
        .font(.footnote)
        .foregroundColor(.secondary)
    }
    .padding()
    .frame(maxWidth: 400)
    .background(.ultraThinMaterial)
    .cornerRadius(16)
    .shadow(radius: 20)
    .transition(.scale)
  }
}
