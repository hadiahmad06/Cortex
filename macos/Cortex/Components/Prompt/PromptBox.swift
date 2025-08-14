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
      
      HStack(alignment: .center, spacing: 3){
        IconButton(
          systemName: "plus",
          isToggled: .constant(nil),
          tooltip: "Attach Content",
          help: "Attach Content to your prompt"
        )
        IconButton(
          systemName: "globe",
          isToggled: .constant(nil),
          tooltip: "Search the Web",
          help: "Enable web searching in your prompt"
        )
        IconButton(
          systemName: "puzzlepiece.extension",
          isToggled: .constant(nil),
          tooltip: "Work with Apps",
          help: "Connect with other apps and tools"
        )
        Spacer()
        IconButton(
          systemName: "mic.fill",
          isToggled: .constant(nil),
          tooltip: "Transcribe voice",
          help: "Use voice to write your prompt"
        )
        Button(action: {
          // Send action
        }) {
          Image(systemName: "arrow.up")
            .foregroundColor(ctx.promptContext.inputText.isEmpty ? .black : .black.opacity(0.8))
            .font(.system(size: 18, weight: .medium))
            .frame(width: 36, height: 36)
            .background(
              Circle()
                .fill(ctx.promptContext.inputText.isEmpty ? Color.gray.opacity(0.75) : Color.white)
            )
            .help("Submit prompt")
            .accessibilityLabel("Submit the prompt")
        }
        .padding(.leading, 8)
        .disabled(ctx.promptContext.inputText.isEmpty)
        .buttonStyle(PlainButtonStyle())
      }
      .padding(.bottom, 8)
      .padding(.horizontal, 12)
    }
    .background(Color.white.opacity(0.05))
    .cornerRadius(24)
    .padding()
  }
}
