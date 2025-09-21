//
//  ChatError.swift
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
    VStack(spacing: 16) {
      // Icon
      Image(systemName: error.symbol)
        .font(.system(size: 50))
        .foregroundColor(error.color)
        .padding(.top, 20)

      // Title
      Text(error.title)
        .font(.title2.bold())
        .foregroundColor(.primary)
        .multilineTextAlignment(.center)

      // Description
      Text(error.description)
        .font(.body)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal)

      Spacer()
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16)
        .shadow(color: error.color.opacity(0.3), radius: 8, x: 0, y: 4)
    )
    .padding(.horizontal, 24)
  }
}


#Preview {
  ChatErrorView(.badAPIKey)
}
