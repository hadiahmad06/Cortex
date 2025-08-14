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

class AppContexts: ObservableObject {
    @Published var promptContext: PromptContext = PromptContext()

    var inputText: String {
        get { promptContext.inputText }
        set { promptContext.inputText = newValue }
    }
}

@main
struct CortexApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  private var appContexts = AppContexts()
  
  init() {
    OverlayWindowController.shared.contexts = appContexts
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(appContexts)
    }
  }
}
