//
//  ChatErrorView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/20/25.
//

import SwiftUI

struct ChatErrorView: View {
  var error: ChatError

  init(_ error: ChatError) {
      self.error = error
  }

  var body: some View {
    HStack(spacing: 12) {
      // Icon
      Image(systemName: error.symbol)
        .font(.title2)
        .foregroundColor(error.color)
        .frame(width: 32)
      
      VStack(alignment: .leading, spacing: 2) {
        // Title
        Text(error.title)
          .font(.headline)
          .foregroundColor(.primary)
        
        // Description
        Text(error.description)
          .font(.subheadline)
          .foregroundColor(.secondary)
          .lineLimit(2)
      }
      Spacer()
    }
    .padding(12)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color(error.color).opacity(0.35))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(error.color.opacity(0.6), lineWidth: 1)
    )
    .padding(.horizontal, 24)
  }
}

#Preview {
  VStack {
    ChatErrorView(.noInternet)
    ChatErrorView(.badAPIKey)
    ChatErrorView(.badRequest(message: "test message"))
    ChatErrorView(.unknown(message: "test message"))
  }
  .padding()
}
