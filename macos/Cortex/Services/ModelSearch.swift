//
//  ModelSearch.swift
//  Cortex
//
//  Created by Hadi Ahmad on 10/3/25.
//

import Foundation

import Foundation

struct ModelFilterSettings {
  var tags: [String] = []
  var maxTokens: Int?
  var modelType: String?
}

struct ModelSearch {
  static func fetchModels(
    apiKey: String?,
    filters: ModelFilterSettings,
    completion: @escaping (Result<[OpenRouterModel], Error>) -> Void
  ) {
    Task {
      func buildURL(baseURL: String, filters: ModelFilterSettings) -> URL? {
        var components = URLComponents(string: baseURL)
        var queryItems: [URLQueryItem] = []
        if !filters.tags.isEmpty {
          queryItems.append(URLQueryItem(name: "tags", value: filters.tags.joined(separator: ",")))
        }
        if let maxTokens = filters.maxTokens {
          queryItems.append(URLQueryItem(name: "max_tokens", value: "\(maxTokens)"))
        }
        if let modelType = filters.modelType {
          queryItems.append(URLQueryItem(name: "model_type", value: modelType))
        }
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        return components?.url
      }
      
      let urlsToTry: [String] = {
        if let _ = apiKey {
          return ["https://openrouter.ai/api/v1/models/user", "https://openrouter.ai/api/v1/models"]
        } else {
          return ["https://openrouter.ai/api/v1/models"]
        }
      }()
      
      var lastError: Error? = nil
      
      for urlString in urlsToTry {
        guard let url = buildURL(baseURL: urlString, filters: filters) else {
          lastError = URLError(.badURL)
          continue
        }
        
        var request = URLRequest(url: url)
        if let key = apiKey {
          request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "GET"
        
        do {
          let (data, _) = try await URLSession.shared.data(for: request)
          let models = try JSONDecoder().decode([OpenRouterModel].self, from: data)
          DispatchQueue.main.async {
            completion(.success(models))
          }
          return
        } catch {
          lastError = error
          continue
        }
      }
      
      // If all attempts fail
      DispatchQueue.main.async {
        completion(.failure(lastError ?? URLError(.badServerResponse)))
      }
    }
  }
}
