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

//@MainActor
//class AppContexts: ObservableObject {
//  static var ctx = AppContexts()
//  
////  @Published var promptContext: PromptContext = PromptContext()
//  @Published var chatContext: ChatManager = ChatManager()
//  @Published var settings: SettingsManager = SettingsManager()
//  @Published var tutorial: TutorialManager = TutorialManager()
//  
//  private init() {}
//}

@main
struct CortexApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  @StateObject private var chat: ChatManager = ChatManager()
  @StateObject private var settings: SettingsManager = SettingsManager()
  @StateObject private var tutorial: TutorialManager = TutorialManager()
  
  init() {
    chat.settings = settings
    OverlayWindowController.shared.chat = chat
    OverlayWindowController.shared.settings = settings
    OverlayWindowController.shared.tutorial = tutorial
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(chat)
        .environmentObject(settings)
        .environmentObject(tutorial)
      
    }
  }
}
