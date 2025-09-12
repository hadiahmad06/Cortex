//
//  ChatContainer.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/2/25.
//

import SwiftUI

struct ChatContainer: View {
  @EnvironmentObject var chatManager: ChatManager
  var isOverlay: Bool
  
  var session: ChatSession {
    let id = isOverlay ? chatManager.overlayChatID : chatManager.windowChatID
    return chatManager.session(for: id)
  }
  
  var body: some View {
    VStack {
//      Text(session.id.uuidString)
      if !session.isDraft {
        ChatView(session: session)
      } else {
        if (!isOverlay) {
          VStack(spacing: 8) {
            Text("Start chatting now!")
              .font(.title2)
              .fontWeight(.semibold)
              .frame(maxWidth: .infinity, alignment: .center)
              .multilineTextAlignment(.center)
            Text("Pick any model you like — or let us choose one for you.")
              .font(.body)
              .foregroundColor(.secondary)
              .multilineTextAlignment(.center)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
      }
      PromptBox(session: session)
    }
    .id(isOverlay ? chatManager.overlayChatID : chatManager.windowChatID)
  }
}
