//
//  ChatError.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/20/25.
//

import SwiftUI

enum ChatError: Identifiable {
  case noInternet
  case badAPIKey
  case badRequest(message: String)
  case unknown(message: String)
  
  var shouldRetry: Bool {
    switch self {
    case .noInternet, .badRequest: return true
    case .badAPIKey, .unknown: return false
    }
  }
  
  var id: String {
    switch self {
    case .noInternet: return "noInternet"
    case .badAPIKey: return "badAPIKey"
    case .badRequest: return "badRequest"
    case .unknown: return "unknown"
    }
  }
  
  var httpStatusCode: Int? {
      switch self {
      case .badAPIKey: return 401
      case .badRequest: return 400
      default: return nil
      }
  }
  
  // MARK: - Info for UI
  
  var title: String {
    switch self {
    case .noInternet: return "No Internet"
    case .badAPIKey: return "Invalid API Key"
    case .badRequest: return "Bad Request"
    case .unknown: return "Unknown Error"
    }
  }
  
  var description: String {
    switch self {
    case .noInternet: return "Please check your internet connection and try again."
    case .badAPIKey: return "Your API key is invalid. Update it in settings to continue."
    case .badRequest(let message): return message
    case .unknown(let message): return message
    }
  }
  
  var symbol: String {
    switch self {
    case .noInternet: return "wifi.exclamationmark"
    case .badAPIKey: return "key.fill"
    case .badRequest: return "exclamationmark.triangle.fill"
    case .unknown: return "questionmark.circle.fill"
    }
  }
  
  var color: Color {
    switch self {
    case .noInternet: return .orange
    case .badAPIKey: return .red
    case .badRequest: return .yellow
    case .unknown: return .gray
    }
  }
}
