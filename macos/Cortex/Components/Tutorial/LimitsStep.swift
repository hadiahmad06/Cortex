//
//  LimitsStep.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/12/25.
//

import SwiftUI

struct LimitsStep: View, TutorialStepView {
    @ObservedObject var settings: SettingsManager

    var step: TutorialStep = .limits

    func nextValidation() -> Bool {
        let s = settings.settings
        return s.chatHistoryLength > 0 &&
               s.requestLimit > 0 &&
               s.maxTokensPerRequest > 0 &&
               s.dailyTokenCap > 0
    }

    func skipValidation() -> Bool { true }

    var erased: AnyView { AnyView(self) }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Set API Usage Limits")
                .font(.title)
                .fontWeight(.bold)

            Text("this whole view should be hidden Configure how many messages are stored and how many requests per session are allowed.")
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            // Chat history length — 4 options only
          SettingsSection(title: "Usage Limits") {
            SettingsRow(title: "Chat history length", content: {
              MultiToggle(
                options: [
                  ToggleOption(id: 5, label: "0"),
                  ToggleOption(id: 10, label: "5"),
                  ToggleOption(id: 25, label: "7"),
                  ToggleOption(id: 50, label: "10")
                ],
                selected: $settings.settings.chatHistoryLength
              )
            })
            
            // Request limit — 4 options only
            SettingsRow(title: "Request limit", content: {
              MultiToggle(
                options: [
                  ToggleOption(id: 10, label: "10"),
                  ToggleOption(id: 50, label: "50"),
                  ToggleOption(id: 100, label: "100"),
                  ToggleOption(id: 500, label: "500")
                ],
                selected: $settings.settings.requestLimit
              )
            })
            
            // Max tokens per request — 4 options only
            SettingsRow(title: "Max tokens per request", content: {
              MultiToggle(
                options: [
                  ToggleOption(id: 1000, label: "1k"),
                  ToggleOption(id: 4000, label: "4k"),
                  ToggleOption(id: 8000, label: "8k"),
                  ToggleOption(id: 16000, label: "16k"),
                  ToggleOption(id: 32000, label: "32k"),
                  ToggleOption(id: -1, label: "None")
                ],
                selected: $settings.settings.maxTokensPerRequest,
                optionHeight: 20,
                optionWidth: 50
              )
            })
            
            // Daily token cap — 4 options only
            SettingsRow(title: "Daily token cap", content: {
              MultiToggle(
                options: [
                  ToggleOption(id: 10000, label: "10000"),
                  ToggleOption(id: 50000, label: "50000"),
                  ToggleOption(id: 100000, label: "100000"),
                  ToggleOption(id: 500000, label: "500000")
                ],
                selected: $settings.settings.dailyTokenCap
              )
            })
            
            // Token cap override toggle
            SettingsRow(
              title: "Allow token cap override",
              content: {
                Toggle("", isOn: $settings.settings.allowTokenCapOverride)
                  .labelsHidden()
                  .toggleStyle(SwitchToggleStyle())
              }
            )
          }

            Text("You can change these settings later in Preferences.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: 600)
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
  tutorial.complete(step: .addKey)
  
  let settings = SettingsManager()
  let chatManager = ChatManager(settings: settings)

  return ContentView()
    .environmentObject(tutorial)
    .environmentObject(chatManager)
    .environmentObject(settings)
    .frame(width: 600, height: 400)
    .padding()

}
