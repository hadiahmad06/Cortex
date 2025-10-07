//
//  TitleArea.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/3/25.
//

import SwiftUI

struct TitleArea: View {
  @ObservedObject var session: ChatSession
  
  init(_ session: ChatSession) {
    self.session = session
  }
  
  var body: some View {
    
//    Text(session.id.uuidString)
    if session.isDraft {
      Spacer()
    } else {
      if session.aliases.isEmpty {
        HStack {
          TextField("Enter Chat Title", text: $session.title)
            .font(.system(size: 16, weight: .semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .textFieldStyle(PlainTextFieldStyle())
            .foregroundColor(.primary)
        }
      } else {
        AliasCyclerView(aliases: session.aliases)
      }
    }
  }
}
