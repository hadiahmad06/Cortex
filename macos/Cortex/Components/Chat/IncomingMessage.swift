//
//  IncomingMessage.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/16/25.
//

import SwiftUI

struct IncomingMessage: View {
  @ObservedObject var chatSessionContext: ChatSession
  
  @State private var animation: Double = 1.0
  
  var body: some View {
    let text = chatSessionContext.incomingMessageText
    let isTyping = chatSessionContext.isIncoming
    let isEmpty = text.isEmpty
    
    if isTyping {
      if isEmpty {
        HStack {
          HStack(spacing: 4) {
            ForEach(0..<3) { i in
              Circle()
                .fill(.white.opacity(0.75))
                .frame(width: 8, height: 8)
                .opacity(0.5 + 0.5*animation)
                .offset(y: CGFloat(Int(animation) * 12) - 12)
                .animation(
                  .easeInOut(duration: 0.6)
                  .repeatForever()
                  .delay(Double(i) * 0.2),
                  value: animation
                )
            }
          }
          .frame(width: 40, height: 24)
          .frame(maxWidth: .infinity, alignment: .leading)
          .onAppear {
            animation = 1
            withAnimation(
              .easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
              animation = (animation + 1).truncatingRemainder(dividingBy: 3)
            }
          }
        }
      } else if isTyping && !isEmpty {
        let (segments, isInlineOnly) = MarkdownRenderer.render(text, incoming: true)
        VStack(alignment: .leading, spacing: 0) {
          ForEach(0..<segments.count, id: \.self) { i in
            segments[i]
          }
        }
        .background(.clear)
        .frame(maxWidth: .infinity, alignment: .leading)
        Spacer()
      }
    } else {
      EmptyView()
    }
  }
}

//#Preview {
//  IncomingMessage(chatSessionContext: AppContexts.ctx.chatContext.session(for: nil))
//}
