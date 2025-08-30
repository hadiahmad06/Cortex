//
//  SettingsButton.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/29/25.
//

import SwiftUI

struct SettingsButton: View {
  var body: some View {
    HStack(spacing: 4) {
      Text("Settings")
        .font(.title3)
        .fontWeight(.bold)
      IconButton(
        systemName: "gear",
        action: {},
        isToggled: .constant(false),
        tooltip: "Settings (⌘I)",
        help: "Open settings menu",
        size: 32,
        fontSize: 16
      )
    }
    .padding(.bottom, 20)
  }
}
