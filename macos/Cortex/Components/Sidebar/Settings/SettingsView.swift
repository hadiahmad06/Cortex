//
//  SettingsView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/6/25.
//

import SwiftUI



struct SettingsView: View {
  @ObservedObject var manager: SettingsManager

  var body: some View {
    VStack {
      ScrollView {
        LazyVStack {
          SettingsSection(title: "Session Timeout") {
            SettingsRow(title: "Reset to New Chat", pv: 5) {
              HStack {
                Toggle("", isOn: $manager.settings.sessionTimeout)
                  .labelsHidden()
                  .toggleStyle(SwitchToggleStyle())
              }
            }
            SettingsRow(title: "Timeout Length", pv: 5) {
              HStack {
                MultiToggle(
                  options: SettingsDefaults.timeoutOptions,
                  selected: $manager.settings.sessionTimeoutMinutes,
                  accentColor: Color.accentColor.opacity(manager.settings.sessionTimeout ? 0.75 : 0.4),
                  fontSize: 12,
                  optionHeight: 20,
                  optionWidth: 30,
                  padding: 2
                )
              }
            }
          }
          
          SettingsSection(title: "API Keys") {
            Text("OpenRouter")
              .font(.caption)
              .foregroundColor(.secondary)
              .frame(maxWidth: .infinity, alignment: .trailing)
            SettingsRow() {
              
              APIKeyTextField(
                placeholder: "OpenRouter API Key",
                apiKey: $manager.settings.openrouter_api_key
              )
            }
//            SettingsRow(title: "Appearance")
          }
//          
//          SettingsSection(title: "About") {
//            SettingsRow(title: "Version")
//            SettingsRow(title: "Licenses")
//          }
        }
      }
    }
    .padding(.horizontal, 12)
//    .scrollContentBackground(.hidden)
//    .listRowBackground(Color.clear)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

// Reusable components
struct SettingsSection<Content: View>: View {
  let title: String
  let content: Content
  
  init(title: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(title)
        .font(.headline)
        .foregroundColor(.secondary)
        .padding(.top, 8)
        .padding(.bottom, 4)
      content
//      Divider()
//        .padding(.top, 6)
    }
    .background(Color.clear)
  }
}

struct SettingsRow<Content: View>: View {
  let title: String?
  @State private var isHovered = false
  let pv: CGFloat
  let content: () -> Content
  
  init(
    title: String? = nil,
    pv: CGFloat = 4,
    @ViewBuilder content: @escaping () -> Content = { EmptyView() }
  ){
    self.title = title
    self.pv = pv
    self.content = content
  }
  
  var body: some View {
    HStack {
      if let title = title {
        Text(title)
        Spacer()
      }
//      Image(systemName: "chevron.right")
//          .foregroundColor(.gray)
      content()
          
    }
    .padding(.vertical, pv)
    .padding(.horizontal, 8)
    .background(isHovered ? Color.gray.opacity(0.2) : Color.gray.opacity(0.05))
    .cornerRadius(8)
    .contentShape(Rectangle())
    .onHover { hovering in
      isHovered = hovering
    }
    .listRowBackground(Color.clear)
  }
}

struct SettingsDefaults {
  static let timeoutOptions = [
    ToggleOption(id: 5, label: "5"),
    ToggleOption(id: 15, label: "15"),
    ToggleOption(id: 30, label: "30")
  ]
}
