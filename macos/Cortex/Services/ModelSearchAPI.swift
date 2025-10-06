//
//  ModelSearch.swift
//  Cortex
//
//  Created by Hadi Ahmad on 10/3/25.
//

import Foundation

struct ModelFilterSettings {
//  var tags: [String] = []
//  var maxTokens: Int?
//  var modelType: String?
  var search: String?
}

struct ModelSearchAPI {
  static var availableModelsCache: [OpenRouterModel] = []
  
  private static func fuzzyMatch(_ query: String, in text: String) -> Bool {
    let pattern = query.map { NSRegularExpression.escapedPattern(for: String($0)) }.joined(separator: ".*")
    return text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
  }
  
  private static func fetchFromAPI(
    apiKey: String?,
    filters: ModelFilterSettings,
    completion: @escaping (Result<[OpenRouterModel], Error>) -> Void
  ) {
    Task {
      let urlsToTry: [String] = {
        if let _ = apiKey {
          return ["https://openrouter.ai/api/v1/models/user", "https://openrouter.ai/api/v1/models"]
        } else {
          return ["https://openrouter.ai/api/v1/models"]
        }
      }()
      
      var lastError: Error? = nil
      
      for urlString in urlsToTry {
        print("Trying URL: \(urlString)")
        guard let url = URL(string: urlString) else {
          lastError = URLError(.badURL)
          continue
        }
        
        var request = URLRequest(url: url)
        if let key = apiKey {
          request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "GET"
        
//        struct OpenRouterModelSearchResponse: Decodable {
//          let data: [OpenRouterModel]
//        }
        
        do {
          print("Starting request to \(urlString)")
          let (data, _) = try await URLSession.shared.data(for: request)
          
          // Use JSONSerialization to parse and decode each model individually
          let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
          guard let dict = jsonObject as? [String: Any],
                let dataArray = dict["data"] as? [Any] else {
            throw URLError(.cannotParseResponse)
          }
          
          var validModels: [OpenRouterModel] = []
          let decoder = JSONDecoder()
          
          for (index, item) in dataArray.enumerated() {
            do {
              let itemData = try JSONSerialization.data(withJSONObject: item, options: [])
              let model = try decoder.decode(OpenRouterModel.self, from: itemData)
              validModels.append(model)
            } catch {
              print("Skipping invalid model at index \(index) due to decoding error: \(error)")
            }
          }
          
          print("Request to \(urlString) succeeded with \(validModels.count) valid models")
          DispatchQueue.main.async {
            self.availableModelsCache = validModels
            completion(.success(validModels))
          }
          return
        } catch {
          print("Request to \(urlString) failed with error: \(error)")
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
  
  static func fetchModels(
    apiKey: String?,
    filters: ModelFilterSettings,
    completion: @escaping (Result<[OpenRouterModel], Error>) -> Void
  ) {
    func applyFuzzySearch(_ models: [OpenRouterModel]) -> [OpenRouterModel] {
      guard let query = filters.search, !query.isEmpty else { return models }
      print("Applying fuzzy search with query: \(query)")
      
      let matchedByName = models.filter { fuzzyMatch(query, in: $0.name) }
      let matchedByDescription = models.filter { model in
        !matchedByName.contains(where: { $0.id == model.id }) && fuzzyMatch(query, in: model.description ?? "")
      }
      let combined = matchedByName + matchedByDescription
      
      return combined
    }

    if !self.availableModelsCache.isEmpty {
      print("Using cached models")
      let filtered = applyFuzzySearch(availableModelsCache)
      print("Returning \(filtered.count) models after filtering")
      completion(.success(filtered))
    } else {
      print("No cached models, fetching from API")
      fetchFromAPI(apiKey: apiKey, filters: filters) { result in
        switch result {
        case .success(let models):
          let filtered = applyFuzzySearch(models)
          print("Returning \(filtered.count) models after filtering")
          completion(.success(filtered))
        case .failure(let error):
          print("Failed to fetch models from API with error: \(error)")
          completion(.failure(error))
        }
      }
    }
    return
  }
}
