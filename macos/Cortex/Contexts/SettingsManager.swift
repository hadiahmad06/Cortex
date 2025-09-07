//
//  SettingsManager.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/6/25.
//

import SwiftUI

class SettingsManager: ObservableObject {
  
  // MARK: API KEYS
  @Published var openrouter_api_key: String = ""
  
  // MARK: APP PREFERENCES
  @Published var autoScroll: Bool = false
  @Published var fontSize: Double = 14
  @Published var sessionTimeout: Bool = true
  @Published var sessionTimeoutMinutes: Int = 15
  
  // TODO: Add AIModel type with Many OpenRouter models.
  // Also allow custom maybe?? ill figure it out
  //  @Published var defaultModel: AIMODEL = .gpt4
  @Published var maxTokens: Int = 1000
  
  
  @Published var enableNotifications: Bool = true
  @Published var notificationSound: Bool = true
  @Published var badgeCountEnabled: Bool = true
  
  // MARK: - Security & Privacy
  @Published var encryptLocalData: Bool = true
  @Published var saveSessionHistory: Bool = true
  @Published var requirePasswordOnLaunch: Bool = false
  
  // MARK: - File & Storage
  @Published var defaultSaveLocation: URL? = nil
  @Published var autoBackupEnabled: Bool = false
  @Published var syncWithCloud: Bool = false
  
  // MARK: - Experimental / Advanced
  @Published var enableStreaming: Bool = true
  @Published var enableDebugLogging: Bool = false
  @Published var proxyURL: String = ""
  @Published var retryOnFailure: Bool = true
  
  
}
