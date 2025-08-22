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
  static var ctx = AppContexts()
  
//  @Published var promptContext: PromptContext = PromptContext()
  @Published var chatContext: ChatManager = ChatManager()
  
  private init() {}
}

@main
struct CortexApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  private var appContexts = AppContexts.ctx
//  init() {
//    OverlayWindowController.shared.contexts = appContexts
//  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(appContexts)
    }
  }
}
