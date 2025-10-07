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
  static var availableModelsCache: [String: OpenRouterModel] = [:]
  
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
            self.availableModelsCache = Dictionary(uniqueKeysWithValues: validModels.map { model in
              let key = model.id
              return (key, model)
            })
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
  
  static func searchModels(
    apiKey: String?,
    filters: ModelFilterSettings,
    completion: @escaping (Result<[ModelTuple], Error>) -> Void
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
      let filtered = applyFuzzySearch(Array(availableModelsCache.values))
      print("Returning \(filtered.count) models after filtering")
      completion(.success(filtered.map( { ModelTuple(id: $0.id, name: $0.name) } )))
    } else {
      print("No cached models, fetching from API")
      fetchFromAPI(apiKey: apiKey, filters: filters) { result in
        switch result {
        case .success(let models):
          let filtered = applyFuzzySearch(models)
          print("Returning \(filtered.count) models after filtering")
          completion(.success(filtered.map( { ModelTuple(id: $0.id, name: $0.name) } )))
        case .failure(let error):
          print("Failed to fetch models from API with error: \(error)")
          completion(.failure(error))
        }
      }
    }
    return
  }
  
  /// Returns all models from the cache whose id is in the given array.
  static func fetchModel(id: String, complete: @escaping (OpenRouterModel?) -> Void) {
    // Step 1: Check cache
    // NOT NECESSARY, but safe to use this method without checking cached, for a latency cost
    if let cachedModel = availableModelsCache[id] {
      complete(cachedModel)
      return
    }
    
    // Step 2: Fetch from API
    let urlString = "https://openrouter.ai/api/v1/models/\(id)/endpoints"
    guard let url = URL(string: urlString) else {
      complete(nil)
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        print("Failed to fetch model \(id): \(error)")
        DispatchQueue.main.async { complete(nil) }
        return
      }
      
      guard let data = data else {
        DispatchQueue.main.async { complete(nil) }
        return
      }
      
      do {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = jsonObject as? [String: Any],
              let dataDict = dict["data"] else {
          DispatchQueue.main.async { complete(nil) }
          return
        }
        let modelData = try JSONSerialization.data(withJSONObject: dataDict, options: [])
        let model = try JSONDecoder().decode(OpenRouterModel.self, from: modelData)
        // Cache it
        DispatchQueue.main.async {
          availableModelsCache[id] = model
          complete(model)
        }
      } catch {
        print("Decoding error for model \(id): \(error)")
        DispatchQueue.main.async { complete(nil) }
      }
    }
    
    task.resume()
  }
}
