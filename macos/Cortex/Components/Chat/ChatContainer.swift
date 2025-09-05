//
//  ChatContainer.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/2/25.
//

import SwiftUI

struct ChatContainer: View {
  @EnvironmentObject var ctx: AppContexts
  var isOverlay: Bool
  
  @ObservedObject var chatManager: ChatManager
  
  init(isOverlay: Bool) {
    self.isOverlay = isOverlay
    self._chatManager = ObservedObject(wrappedValue: AppContexts.ctx.chatContext)
  }
  
  var session: ChatSession {
    let id = isOverlay ? chatManager.overlayChatID : chatManager.windowChatID
    return chatManager.session(for: id)
  }
  
  
  var body: some View {
    ZStack {
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
    }
    .id(chatManager.windowChatID)
  }
}
