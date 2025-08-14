//
//  OverlayWindowController.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import AppKit
import SwiftUI

class OverlayWindowController {
  static let shared = OverlayWindowController()
  private var panel: NSPanel?

  var contexts: AppContexts?
  
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
    let width: CGFloat = 400
    let height: CGFloat = 400
    let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
    let x = screen.midX - width / 2
    let y = screen.maxY - height - 40

    let panel = NSPanel(
      contentRect: NSRect(x: x, y: y, width: width, height: height),
      styleMask: [.nonactivatingPanel, .titled],
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
    panel.becomesKeyOnlyIfNeeded = true

    let hosting = NSHostingView(
        rootView: OverlayView()
            .environmentObject(contexts!)
    )
    panel.contentView = hosting

    self.panel = panel
  }
}
