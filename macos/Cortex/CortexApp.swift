//
//  CortexApp.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    registerGlobalHotkey()
  }

  func applicationWillTerminate(_ notification: Notification) {
    unregisterGlobalHotkey()
  }
}

@main
struct CortexApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @StateObject private var promptContext = PromptContext()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(promptContext)
    }
  }
}
