//
//  ChatView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/14/25.
//

import SwiftUI

struct ChatView: View {
  // Hover tracking
  @State private var hoveredMessageID: UUID?
  
  @ObservedObject var session: ChatSession
  
  private func loadSession() {
//    session.messages = ChatAPI.fetchMessages(for: session.id)
    print(session.messages)
  }
  
  // TODO: fix issue where ContentView doesnt update when a message is added.
  var body: some View {
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
          }
        }
    
        IncomingMessage(chatSessionContext: session)
          .padding(.bottom, 28)
        
        if let error = session.error {
          ChatErrorView(error)
            .padding(.vertical, 8)
        }
      }
      .padding(20)
      .onAppear {
        loadSession()
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
//    .id(msg.id)
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
//    .id(msg.id)
  }
}

#Preview {
  let settings = SettingsManager()
  let chatManager = ChatManager(settings: settings)

  ChatContainer(isOverlay: true)
    .environmentObject(chatManager)
    .environmentObject(settings)
    .environmentObject(TutorialManager())
}


//struct ChatView_Previews: PreviewProvider {
//  
//  
//  struct StreamingPreview: View {
//    private var chatSessionContext: ChatSession
//    
//    init() {
//      chatSessionContext = AppContexts.ctx.chatContext.session()
//      AppContexts.ctx.chatContext.overlayChatID = chatSessionContext.id
//    }
//    
//    let fullMessage = "Hello! This is a streaming message. It will appear character by character to simulate an LLM response."
//    @State private var timer: Timer? = nil
//    @State private var index: Int = 0
//
//    var body: some View {
//      ChatContainer(isOverlay: true)
//        .onAppear {
//          chatSessionContext.startIncomingMessage()
//          index = 0
//          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            timer?.invalidate()
//            timer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { t in
//              if index < fullMessage.count {
//                let nextChar = fullMessage[fullMessage.index(fullMessage.startIndex, offsetBy: index)]
//                chatSessionContext.addIncomingChunk(String(nextChar))
//                index += 1
//              } else {
//                t.invalidate()
//                DispatchQueue.main.async {
//                  chatSessionContext.finalizeIncomingMessage(id: UUID())
//                }
//              }
//            }
//          }
//        }
//        .onDisappear {
//            timer?.invalidate()
//        }
//    }
//  }
//  
//  static var previews: some View {
//    StreamingPreview()
//  }
//}
