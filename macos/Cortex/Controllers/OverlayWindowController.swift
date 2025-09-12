//
//  OverlayWindowController.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import AppKit
import SwiftUI

@MainActor
class OverlayWindowController: NSObject, NSWindowDelegate {
  static let shared = OverlayWindowController()
  private var panel: NSPanel?

  var chat: ChatManager?
  var settings: SettingsManager?
  var tutorial: TutorialManager?
  
  private let minWidth: CGFloat = 350
  private let maxWidth: CGFloat = 600
  private let minHeight: CGFloat = 300
  private let maxHeight: CGFloat = 1000
  
  func toggle() {
    if panel == nil {
      createPanel()
    }

    guard let panel = panel else { return }

    if panel.isVisible {
      panel.orderOut(nil)
    } else {
      panel.makeKeyAndOrderFront(nil)
    }
  }

  private func createPanel() {
    guard let chat = chat, let settings = settings, let tutorial = tutorial else {
      print("OverlayWindowController: Cannot create panel — one or more managers are nil.")
      return
    }
    
    let width: CGFloat = 400
    let height: CGFloat = 400
    let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
    let x = screen.midX - width / 2
    let y = screen.maxY - height - 40

    let panel = NSPanel(
      contentRect: NSRect(x: x, y: y, width: width, height: height),
      styleMask: [.nonactivatingPanel, .resizable],
      backing: .buffered,
      defer: false
    )

    panel.isFloatingPanel = true
    panel.level = .screenSaver
    panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient]
    panel.backgroundColor = .clear
    panel.isOpaque = false
    panel.hasShadow = true
    panel.ignoresMouseEvents = false
    panel.hidesOnDeactivate = false
    panel.titleVisibility = .hidden
    panel.titlebarAppearsTransparent = true
    panel.isMovableByWindowBackground = true
    panel.becomesKeyOnlyIfNeeded = false
    panel.makeKeyAndOrderFront(nil)
    panel.minSize = NSSize(width: minWidth, height: minHeight)
    panel.maxSize = NSSize(width: maxWidth, height: maxHeight)
    panel.delegate = self

    let hosting = NSHostingView(
      rootView: OverlayView()
        .background(Color.clear.contentShape(Rectangle()))
        .environmentObject(chat)
        .environmentObject(settings)
        .environmentObject(tutorial)
    )
    panel.contentView = hosting

    self.panel = panel
  }

  func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
    let width = min(max(frameSize.width, minWidth), maxWidth)   // clamp width
    let height = min(max(frameSize.height, minHeight), maxHeight) // clamp height
    return NSSize(width: width, height: height)
  }
}
