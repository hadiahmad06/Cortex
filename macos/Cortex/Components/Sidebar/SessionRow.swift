//
//  SessionRow.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/29/25.
//

import SwiftUI

struct SessionRow: View {
  let title: String
  let date: Date
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 2) {
        Text(title)
          .font(.headline)
          .foregroundColor(.primary)
          .lineLimit(1)
        Text(date, style: .date)
          .font(.caption)
          .foregroundColor(.secondary)
      }
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundColor(.gray)
    }
    .padding(.vertical, 6)
    .padding(.horizontal, 10)
    .background(
      RoundedRectangle(cornerRadius: 8)
        .fill(Color.gray.opacity(0.1))
    )
  }
}
