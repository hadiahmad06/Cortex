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
    if session.isDraft {
      Spacer()
    } else {
      if session.aliases.isEmpty {
        TextField("Chat Name", text: $session.title)
        .textFieldStyle(.roundedBorder)
        .frame(maxWidth: 200)
      } else {
        AliasCyclerView(aliases: session.aliases)
      }
    }
  }
}
