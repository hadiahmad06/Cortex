//
//  APIKeyTextField.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/6/25.
//

import SwiftUI

struct APIKeyTextField: View {
  var placeholder: String
  @Binding var apiKey: String
  @State private var isVulnerable: Bool = false
  
  var body: some View {
    HStack(spacing: 2) {
      if !isVulnerable {
        SecureField(placeholder, text: $apiKey)
          .font(.system(.body, design: .monospaced))
          .textFieldStyle(.plain)
          .disableAutocorrection(true)
      } else {
        TextField(placeholder, text: $apiKey)
          .font(.system(.body, design: .monospaced))
          .textFieldStyle(.plain)
          .disableAutocorrection(true)
      }
      IconButton(
        systemName: isVulnerable ? "eye" : "eye.slash",
        isToggled: $isVulnerable,
        size: 28,
        fontSize: 14
      )
      IconButton(
        systemName: "doc.on.doc",
        action: {
          #if os(iOS)
          UIPasteboard.general.string = apiKey
          #elseif os(macOS)
          let pasteboard = NSPasteboard.general
          pasteboard.clearContents()
          pasteboard.setString(apiKey, forType: .string)
          #endif
        },
        isToggled: .constant(false),
        size: 28,
        fontSize: 14
      )
    }
  }
}
