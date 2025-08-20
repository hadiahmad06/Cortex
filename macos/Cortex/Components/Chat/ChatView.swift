//
//  ChatView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/14/25.
//

import SwiftUI

struct Message: Identifiable {
  let id: UUID
  let text: String
  let isUser: Bool
  var isPinned: Bool
  let timestamp: Date
}

struct ChatView: View {
  @EnvironmentObject var ctx: AppContexts
  var isOverlay: Bool
  
  // Hover tracking
  @State private var hoveredMessageID: UUID?
  
  @ObservedObject var session: ChatSessionContext

  init(isOverlay: Bool) {
    self.isOverlay = isOverlay
    let manager = AppContexts.ctx.chatContext
    let resolvedSession = isOverlay
      ? manager.session(for: manager.overlayChatID)
      : manager.session(for: manager.windowChatID)
    _session = ObservedObject(initialValue: resolvedSession)
  }
  
  private func loadSession() {
    session.messages = ChatAPI.fetchMessages(for: session.id)
    print(session.messages)
  }
  
  var body: some View {
    if (!isOverlay && session.messages.isEmpty) {
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
    } else {
      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(Array(session.messages.enumerated()), id: \.element.id) { index, msg in
            VStack(spacing: 0) {
              if index == 0 {
                IconButtonDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
                ChatMessage(msg: msg)
                  .onHover { hover in
                    hoveredMessageID = hover ? msg.id : nil
                  }
              } else if index == session.messages.count - 1 {
                let prevMsg = session.messages[index - 1]
                HStack(spacing: 0) {
                  if msg.isUser {
                    MessageFooterDupe(msg: prevMsg, hoveredMessageID: $hoveredMessageID)
                    IconButtonDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
                  } else {
                    IconButtonDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
                    MessageFooterDupe(msg: prevMsg, hoveredMessageID: $hoveredMessageID)
                  }
                }
                ChatMessage(msg: msg)
                  .onHover { hover in
                    hoveredMessageID = hover ? msg.id : nil
                  }
                MessageFooterDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
              } else {
                let prevMsg = session.messages[index - 1]
                HStack(spacing: 0) {
                  if msg.isUser {
                    MessageFooterDupe(msg: prevMsg, hoveredMessageID: $hoveredMessageID)
                    IconButtonDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
                  } else {
                    IconButtonDupe(msg: msg, hoveredMessageID: $hoveredMessageID)
                    MessageFooterDupe(msg: prevMsg, hoveredMessageID: $hoveredMessageID)
                  }
                }
                ChatMessage(msg: msg)
                  .onHover { hover in
                    hoveredMessageID = hover ? msg.id : nil
                  }
              }
              IncomingMessage(chatSessionContext: session)
            }
          }
        }
        .padding(20)
        .id(session)
        .onAppear {
          loadSession()
        }
      }
    }
  }
}

struct IconButtonDupe: View {
  let msg: Message
  @Binding var hoveredMessageID: UUID?
  
  var body: some View {
    HStack(spacing: 0) {
      if msg.isUser { Spacer() }
      IconButton(
        systemName: msg.isPinned ? "pin.fill" : "pin",
        foregroundColor: .red,
        action: {}, //{isPinned.toggle()},
        isToggled: .constant(false),
        tooltip: "",
        help: "",
        size: 28,
        fontSize: 14
      )
      .opacity(msg.isPinned ? 1 : ((msg.id == hoveredMessageID) ? 1 : 0))
      .animation(.easeInOut(duration: 0.2), value: (msg.id == hoveredMessageID))
      .allowsHitTesting((msg.id == hoveredMessageID))
      if !msg.isUser { Spacer() }
    }
    .onHover { hover in
      hoveredMessageID = hover ? msg.id : nil
    }
  }
}

struct MessageFooterDupe: View {
  let msg: Message
  @Binding var hoveredMessageID: UUID?
  
  var body: some View {
    HStack(spacing: 0) {
      if msg.isUser { Spacer() }
      MessageFooter(msg: msg)
        .opacity((msg.id == hoveredMessageID) ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: (msg.id == hoveredMessageID))
        .allowsHitTesting((msg.id == hoveredMessageID))
      if !msg.isUser { Spacer() }
    }
    .onHover { hover in
      hoveredMessageID = hover ? msg.id : nil
    }
  }
}

#Preview {
  ChatView(isOverlay: true)
    .environmentObject(AppContexts.ctx)
}
