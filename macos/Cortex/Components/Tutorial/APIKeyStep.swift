//
//  APIKeyStep.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/11/25.
//

import SwiftUI

struct APIKeyStep: TutorialStepView, View {
  @ObservedObject var settings: SettingsManager
  @Binding var error: String?
  
  var step: TutorialStep { get { return .addKey } }
  var erased: AnyView { AnyView(self) }
  
  func nextValidation() -> Bool {
    let key = settings.settings.openrouter_api_key.trimmingCharacters(in: .whitespacesAndNewlines)
    
    // Example regex for a typical API key:
    // 32–64 alphanumeric characters, optionally with dashes
    let pattern = #"^[A-Za-z0-9\-]{32,64}$"#
    
    if let _ = key.range(of: pattern, options: .regularExpression) {
//      print("passed")
      return true
    } else {
//      print("failed")
      error = "Please enter a valid API key."
      return false
    }
  }
  
  // allow skipping, so that they can explore the app ui.
  func skipValidation() -> Bool { return true }

  var body: some View {
    VStack(spacing: 20) {
      Text("Add Your API Key")
        .font(.title)
        .bold()

      Text("To start chatting, you need to enter your OpenRouter API key. You can find it on the OpenRouter dashboard.")
        .font(.body)
        .multilineTextAlignment(.center)
      
      Text("Don't worry! We don't store your API key anywhere, it's all local.")
        .font(.body)
        .multilineTextAlignment(.center)
      
      SettingsRow(pv: 2, content: {
        APIKeyTextField(
          placeholder: "OpenRouter API Key",
          apiKey: $settings.settings.openrouter_api_key
        )
      })
      
      if let error = error {
        Text(error)
          .font(.body)
          .foregroundColor(.red)
          .multilineTextAlignment(.center)
      }
      
    }
    .padding()
    .frame(maxWidth: 400)
    .background(.ultraThinMaterial)
    .cornerRadius(16)
    .shadow(radius: 20)
    .transition(.scale)
  }
}

#Preview {
  let tutorial = TutorialManager()
  
  tutorial.resetTutorials()
  tutorial.complete(step: .welcome)
  
  let settings = SettingsManager()
  let chatManager = ChatManager(settings: settings)

  return ContentView()
    .environmentObject(tutorial)
    .environmentObject(chatManager)
    .environmentObject(settings)
    .frame(width: 600, height: 400)
    .padding()

}
