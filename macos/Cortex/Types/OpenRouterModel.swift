//
//  OpenRouterModel.swift
//  Cortex
//
//  Created by Hadi Ahmad on 10/3/25.
//


struct OpenRouterModel: Codable, Identifiable {
  let id: String
  let name: String
  let created: Int
  let description: String?
  let architecture: Architecture
  let topProvider: TopProvider
  let pricing: Pricing
  let canonicalSlug: String
  let contextLength: Int
  let huggingFaceId: String?
  let perRequestLimits: [String: Int]?
  let supportedParameters: [String]
  let defaultParameters: DefaultParameters
  
  struct Architecture: Codable {
    let inputModalities: [String]
    let outputModalities: [String]
    let tokenizer: String
    let instructType: String?
    
    enum CodingKeys: String, CodingKey {
      case inputModalities = "input_modalities"
      case outputModalities = "output_modalities"
      case tokenizer
      case instructType = "instruct_type"
    }
  }
  
  struct TopProvider: Codable {
    let isModerated: Bool
    let contextLength: Int
    let maxCompletionTokens: Int
    
    enum CodingKeys: String, CodingKey {
      case isModerated = "is_moderated"
      case contextLength = "context_length"
      case maxCompletionTokens = "max_completion_tokens"
    }
  }
  
  struct Pricing: Codable {
    let prompt: String
    let completion: String
    let image: String
    let request: String
    let webSearch: String
    let internalReasoning: String
    let inputCacheRead: String
    let inputCacheWrite: String
    
    var promptValue: Double? { Double(prompt) }
    var completionValue: Double? { Double(completion) }
    var imageValue: Double? { Double(image) }
    var requestValue: Double? { Double(request) }
    var webSearchValue: Double? { Double(webSearch) }
    var internalReasoningValue: Double? { Double(internalReasoning) }
    var inputCacheReadValue: Double? { Double(inputCacheRead) }
    var inputCacheWriteValue: Double? { Double(inputCacheWrite) }
    
    enum CodingKeys: String, CodingKey {
      case prompt
      case completion
      case image
      case request
      case webSearch = "web_search"
      case internalReasoning = "internal_reasoning"
      case inputCacheRead = "input_cache_read"
      case inputCacheWrite = "input_cache_write"
    }
  }
  
  struct DefaultParameters: Codable {
    let temperature: Double
    let topP: Double
    let frequencyPenalty: Int
    
    enum CodingKeys: String, CodingKey {
      case temperature
      case topP = "top_p"
      case frequencyPenalty = "frequency_penalty"
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case created
    case description
    case architecture
    case topProvider = "top_provider"
    case pricing
    case canonicalSlug = "canonical_slug"
    case contextLength = "context_length"
    case huggingFaceId = "hugging_face_id"
    case perRequestLimits = "per_request_limits"
    case supportedParameters = "supported_parameters"
    case defaultParameters = "default_parameters"
  }
}
