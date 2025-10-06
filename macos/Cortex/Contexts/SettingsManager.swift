//
//  SettingsManager.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/6/25.
//

import SwiftUI
import Combine

// MARK: - Codable Struct for All Settings
struct AppSettings: Codable {
  // API Keys
  var openrouter_api_key: String = ""
  
  // Model
  var savedModels: [OpenRouterModel] = []

  // Chat Limits
  var chatHistoryLength: Int = 3
  var requestLimit: Int = 3
  var maxTokensPerRequest: Int = 1000
  var dailyTokenCap: Int = 10000
  var allowTokenCapOverride: Bool = false
  
  // App Preferences
  var autoScroll: Bool = false
  var fontSize: Double = 14
  var sessionTimeout: Bool = true
  var sessionTimeoutMinutes: Int = 15
  var maxTokens: Int = 1000
  var enableNotifications: Bool = true
  var notificationSound: Bool = true
  var badgeCountEnabled: Bool = true

  // Security & Privacy
  var encryptLocalData: Bool = true
  var saveSessionHistory: Bool = true
  var requirePasswordOnLaunch: Bool = false

  // File & Storage
  var defaultSaveLocation: URL? = nil
  var autoBackupEnabled: Bool = false
  var syncWithCloud: Bool = false

  // Experimental / Advanced
  var enableStreaming: Bool = true
  var enableDebugLogging: Bool = false
  var proxyURL: String = ""
  var retryOnFailure: Bool = true
}

// MARK: - SettingsManager
class SettingsManager: ObservableObject {
    
    @Published var settings = AppSettings()
    
    private var cancellables = Set<AnyCancellable>()
    private let key = "app_settings"

    init() {
      load()
      observeChanges()
    }
    
    // MARK: - Observe All Changes Using Combine
    private func observeChanges() {
      $settings
        .dropFirst() // ignore initial value
        .sink { [weak self] _ in
            self?.save()
        }
        .store(in: &cancellables)
    }

    // MARK: - Persistence
    private func save() {
      if let data = try? JSONEncoder().encode(settings) {
        UserDefaults.standard.set(data, forKey: key)
      }
    }
    
    private func load() {
      guard let data = UserDefaults.standard.data(forKey: key),
          let saved = try? JSONDecoder().decode(AppSettings.self, from: data)
      else { return }
      
      self.settings = saved
    }
}
