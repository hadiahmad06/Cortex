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
  @FocusState private var isTextFieldFocused: Bool
  @State private var inputText: String = ""
  @State private var isHovered: Bool = false

  private var isScrollable: Bool {
    inputText.components(separatedBy: .newlines).count > 10
  }

  var body: some View {
    ZStack {
      ZStack {
        VisualEffectBlur()
          .overlay(Color.black.opacity(0.25))

        VStack {
            if isHovered {
              HStack {
                Button(action: {
                  dismiss()
                }) {
                  Image(systemName: "xmark")
                    .foregroundColor(.white)
    //                  .padding(8)
                }
                .buttonStyle(PlainButtonStyle())

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
                Text("Mustard Blud")
                  .font(.body)
                  .foregroundColor(.white.opacity(0.4))
                  .padding(.vertical, 12)
                  .padding(.horizontal, 16)
              }
              TextEditor(text: $inputText)
                .font(.body)
                .padding(12)
                .frame(minHeight: 20, maxHeight: 100)
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .focused($isTextFieldFocused)
                .disabled(!isScrollable)
                .overlay(Color.white.opacity(0.05))
                .cornerRadius(20)
                .onTapGesture {
                    isTextFieldFocused = true
                }
                .allowsHitTesting(true)
            }
          }
          .padding()
        }
      }
      .cornerRadius(20)
      .onAppear {
        isTextFieldFocused = true
      }
      .animation(.easeInOut(duration: 0.2), value: isHovered)
    }
    .onHover { hovering in
//      print("Hover state: \(hovering)")
      isHovered = hovering
    }
  }
}

struct VisualEffectBlur: NSViewRepresentable {
  func makeNSView(context: Context) -> NSVisualEffectView {
    let view = NSVisualEffectView()
    view.material = .hudWindow
    view.blendingMode = .behindWindow
    view.state = .active
    return view
  }

  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

struct OverlayView_Previews: PreviewProvider {
  static var previews: some View {
    OverlayView()
      .previewLayout(.sizeThatFits)
//      .padding()
  }
}
