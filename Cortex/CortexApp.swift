//
//  CortexApp.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import SwiftUI

@main
struct CortexApp: App {
  init() {
    registerGlobalHotkey()
    print("registerGlobalHotkey() called")
  }
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    Window("CortexOverlay", id: OverlayView.id) {
      OverlayView()
    }
  }
}
