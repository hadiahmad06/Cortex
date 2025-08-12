//
//  OverlayView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import SwiftUI
import AppKit

struct OverlayView: View {
  static let id = "CortexOverlay"
  @Environment(\.dismiss) private var dismiss
  @State private var isFirstResponder: Bool = false // might change later
  @State private var inputText: String = ""
  @State private var isHovered: Bool = false
  @State private var measuredTextHeight: CGFloat = 36


  var body: some View {
    ZStack {
      ZStack {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
          .fill(.ultraThinMaterial)
          .overlay(Color.black.opacity(0.25))

        VStack {
            if isHovered {
              HStack {
                Button(action: {
                  OverlayWindowController.shared.toggle()
                }) {
                  Image(systemName: "xmark")
                    .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(8)
                .accessibilityLabel("Close")
                .help("Close")

                Spacer()

                Button(action: {
                  inputText = ""
                }) {
                  Text("New Chat")
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
              }
              .padding()
              .transition(.opacity)
              .zIndex(1)
            }
          Spacer()
          VStack(alignment: .trailing, spacing: 8) {
            ZStack(alignment: .topLeading) {
              if inputText.isEmpty {
                Text("Type a prompt…")
                  .font(.system(size: 12))
                  .foregroundColor(.white.opacity(0.4))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
              }
              AutoGrowingTextView(text: $inputText, isFirstResponder: $isFirstResponder, measuredHeight: $measuredTextHeight, maxHeight: 120)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.05))
                .onTapGesture {
//                  NSApp.activate(ignoringOtherApps: true)
//                  isFirstResponder = true
                }
            }
            .frame(height: min(max(measuredTextHeight, 40), 120))
            .cornerRadius(20)
          }
          .padding()
        }
      }
      .cornerRadius(20)
//      .onAppear {
//        NSApp.activate(ignoringOtherApps: true)
//        isFirstResponder = true
//      }
      .animation(.easeInOut(duration: 0.2), value: isHovered)
    }
    .onHover { hovering in
//      print("Hover state: \(hovering)")
      isHovered = hovering
    }
    .onExitCommand {
      OverlayWindowController.shared.toggle()
    }
  }
}

struct OverlayView_Previews: PreviewProvider {
  static var previews: some View {
    OverlayView()
      .previewLayout(.sizeThatFits)
//      .padding()
  }
}
