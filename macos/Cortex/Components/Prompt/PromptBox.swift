//
//  PromptBox.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/13/25.
//

import SwiftUI

struct PromptBox: View {
  @EnvironmentObject var ctx: AppContexts
  @State private var isHovered: Bool = false
  @State private var measuredTextHeight: CGFloat = 30
  @State private var isFirstResponder: Bool = false // might change later
  
  var body: some View {
    VStack(alignment: .trailing, spacing: 8) {
      ZStack(alignment: .topLeading) {
        if ctx.promptContext.inputText.isEmpty {
          Text("Type a prompt…")
            .font(.system(size: 12))
            .foregroundColor(.white.opacity(0.4))
        }
        AutoGrowingTextView(
          text: $ctx.promptContext.inputText,
          isFirstResponder: $isFirstResponder,
          measuredHeight: $measuredTextHeight,
          maxHeight: 120
        )
          .onTapGesture {
//            NSApp.activate(ignoringOtherApps: true)
//            isFirstResponder = true
        }
      }
      .frame(height: min(measuredTextHeight, 120))
      .padding(.top, 12)
      .padding(.horizontal, 16)
      
      HStack(alignment: .center){
        HStack(spacing: 8) {
          PromptButton(systemName: "plus", isToggled: .constant(nil))
          // attach documents
          PromptButton(systemName: "globe", isToggled: .constant(nil))
          // web search
          PromptButton(systemName: "puzzlepiece.extension", isToggled: .constant(nil))
          // integrate with other apps
        }
        Spacer()
        HStack(spacing: 8) {
          PromptButton(systemName: "mic.fill", isToggled: .constant(nil))
          // microphone action
          PromptButton(systemName: "square.and.arrow.up", foregroundColor: .primary, isToggled: .constant(nil))
          // upload action
        }
      }
      .padding(.bottom, 8)
      .padding(.horizontal, 12)
    }
    .background(Color.white.opacity(0.05))
    .cornerRadius(20)
    .padding()
  }
}
