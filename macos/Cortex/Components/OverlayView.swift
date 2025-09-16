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
  @State private var isHovered: Bool = false
  @State private var isFirstResponder: Bool = true

  var body: some View {
    ZStack {
      ZStack {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
          .fill(.ultraThinMaterial)
          .overlay(Color.black.opacity(0.1))

        VStack {
          Spacer()
          ChatContainer(isOverlay: true)
        }
        .overlay(
          Group {
            if isHovered {
              HStack {
                IconButton(
                  systemName: "xmark",
                  action: OverlayWindowController.shared.toggle,
                  isToggled: .constant(false),
                  tooltip: "Close (Esc)",
                  help: "Close the overlay",
                  size: 24,
                  fontSize: 14
                )
                Spacer()
                IconButton(
                  systemName: "rectangle.on.rectangle",
                  isToggled: .constant(false),
                  tooltip: "Open in main window (⌘O)",
                  help: "Open chat in main window",
                  size: 24,
                  fontSize: 14
                )
                IconButton(
                  systemName: "square.and.pencil",
                  isToggled: .constant(false),
                  tooltip: "New Chat (⌘N)",
                  help: "Open chat in main window",
                  size: 24,
                  fontSize: 14
                )
              }
              .padding(.horizontal, 8)
              .padding(.vertical, 8)
              .transition(.opacity)
              .zIndex(1)
            }
          },
          alignment: .top
        )
      }
      .cornerRadius(24)
      .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.15), lineWidth: 1).allowsHitTesting(false))
      .animation(.easeInOut(duration: 0.2), value: isHovered)
//      .onAppear {
//        NSApp.activate(ignoringOtherApps: true)
//        isFirstResponder = true
//      }
    }
    .onHover { hovering in
      isHovered = hovering
    }
    .onExitCommand {
      OverlayWindowController.shared.toggle()
    }
    .onTapGesture {
      NSApp.activate(ignoringOtherApps: true)
      isFirstResponder = true
    }
  }
}

struct OverlayView_Previews: PreviewProvider {
  static var previews: some View {
    OverlayView()
      .previewLayout(.sizeThatFits)
      .environmentObject(ChatManager())
      .environmentObject(SettingsManager())
      .environmentObject(TutorialManager())
      .padding()
  }
}
