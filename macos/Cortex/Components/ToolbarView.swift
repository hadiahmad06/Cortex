//
//  ToolbarView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/28/25.
//

import SwiftUI

struct ToolbarView: View {
  var body: some View {
    HStack {
      Text("Cortex")
        .font(.headline)
      Spacer()
      Button("⚙️") {
        // open settings
      }
      .buttonStyle(.plain)
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 6)
    .background(Material.ultraThin)
  }
}
