//
//  OpenRouterModel.swift
//  Cortex
//
//  Created by Hadi Ahmad on 10/3/25.
//

struct ModelTuple: Codable, Equatable {
  let id: String
  let name: String

  static func == (lhs: ModelTuple, rhs: ModelTuple) -> Bool {
    return lhs.id == rhs.id
  }
}

struct OpenRouterModel: Codable, Identifiable {
  let id: String
  let name: String
  let created: Double
  let description: String?
  let architecture: Architecture
  let topProvider: TopProvider
  let pricing: Pricing
  let canonicalSlug: String?
  let contextLength: Int?
  let huggingFaceId: String?
  let perRequestLimits: [String: Int]?
  let supportedParameters: [String]?
  let defaultParameters: DefaultParameters?
  
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
    let contextLength: Double?
    let maxCompletionTokens: Double?
    
    enum CodingKeys: String, CodingKey {
      case isModerated = "is_moderated"
      case contextLength = "context_length"
      case maxCompletionTokens = "max_completion_tokens"
    }
  }
  
  struct Pricing: Codable {
    let prompt: String
    let completion: String
    let image: String? // should be non-optional
    let request: String
    let webSearch: String
    let internalReasoning: String
    let inputCacheRead: String?
    let inputCacheWrite: String?
    
    var promptValue: Double? { Double(prompt) }
    var completionValue: Double? { Double(completion) }
    var imageValue: Double? { image.flatMap(Double.init) }
    var requestValue: Double? { Double(request) }
    var webSearchValue: Double? { Double(webSearch) }
    var internalReasoningValue: Double? { Double(internalReasoning) }
    var inputCacheReadValue: Double? { inputCacheRead.flatMap(Double.init) }
    var inputCacheWriteValue: Double? { inputCacheWrite.flatMap(Double.init) }
    
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
    let temperature: Double?
    let topP: Double?
    let frequencyPenalty: Double?
    
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

extension OpenRouterModel {
  static let exampleModel = OpenRouterModel(
      id: "openai/gpt-5-codex",
      name: "OpenAI: GPT-5 Codex",
      created: 1_758_643_403,
      description: """
  GPT-5-Codex is a specialized version of GPT-5 optimized for software engineering and coding workflows. \
  It is designed for both interactive development sessions and long, independent execution of complex engineering tasks. \
  The model supports building projects from scratch, feature development, debugging, large-scale refactoring, and code review. \
  Compared to GPT-5, Codex is more steerable, adheres closely to developer instructions, and produces cleaner, higher-quality code outputs. \
  Reasoning effort can be adjusted with the `reasoning.effort` parameter. Read the [docs here](https://openrouter.ai/docs/use-cases/reasoning-tokens#reasoning-effort-level).

  Codex integrates into developer environments including the CLI, IDE extensions, GitHub, and cloud tasks. \
  It adapts reasoning effort dynamically—providing fast responses for small tasks while sustaining extended multi-hour runs for large projects. \
  The model is trained to perform structured code reviews, catching critical flaws by reasoning over dependencies and validating behavior against tests. \
  It also supports multimodal inputs such as images or screenshots for UI development and integrates tool use for search, dependency installation, and environment setup. \
  Codex is intended specifically for agentic coding applications.
  """,
      architecture: .init(
          inputModalities: ["text", "image"],
          outputModalities: ["text"],
          tokenizer: "GPT",
          instructType: nil
      ),
      topProvider: .init(
          isModerated: true,
          contextLength: 400_000,
          maxCompletionTokens: 128_000
      ),
      pricing: .init(
          prompt: "0.00000125",
          completion: "0.00001",
          image: "0",
          request: "0",
          webSearch: "0",
          internalReasoning: "0",
          inputCacheRead: "0.000000125",
          inputCacheWrite: nil
      ),
      canonicalSlug: "openai/gpt-5-codex",
      contextLength: 400_000,
      huggingFaceId: "",
      perRequestLimits: nil,
      supportedParameters: [
          "include_reasoning",
          "max_tokens",
          "reasoning",
          "response_format",
          "seed",
          "structured_outputs",
          "tool_choice",
          "tools"
      ],
      defaultParameters: .init(
          temperature: nil,
          topP: nil,
          frequencyPenalty: nil
      )
  )
}
