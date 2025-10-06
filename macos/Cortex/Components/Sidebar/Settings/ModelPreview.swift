//
//  ModelPreview.swift
//  Cortex
//
//  Created by Hadi Ahmad on 10/5/25.
//

import SwiftUI

struct ModelPreview: View {
  @Binding var model: OpenRouterModel?
  @State private var showDescription = false
  
  @State private var perTokenCount: Double = 1_000_000
  
  init(_ model: Binding<OpenRouterModel?>) {
    self._model = model
  }
  
  var body: some View {
    ScrollView {
      if let model = model {
        VStack(alignment: .leading, spacing: 8) {
          // MARK: TITLE, LINK, DATE of CREATION
          VStack(alignment: .leading, spacing: 2) {
            HStack {
              Text("\(model.name)").font(.headline)
              Spacer()
              let dateFormatter: DateFormatter = {
                let df = DateFormatter()
                df.dateStyle = .medium
                return df
              }()
              Text("\(dateFormatter.string(from: Date(timeIntervalSince1970: model.created)))")
                .font(.footnote)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.15))
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .padding(.horizontal, 5)
            Link(destination: URL(string: "https://openrouter.ai/\(model.id)")!) {
              IconButton(
                isToggled: .constant(false),
                size: 18,
                preserveAspectRatio: false
              ){
                HStack(spacing: 6) {
                  Text("\(model.id)")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
                  Image(systemName: "link")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
                }
                .padding(.horizontal, 8)
              }
            }
            
          }
          .padding(.horizontal, 7)
          
          VStack(alignment: .leading, spacing: 8) {
            // MARK: DESCRIPTION POPDOWN
            if let description = model.description {
              VStack(alignment: .leading, spacing: 4) {
                Button {
                  withAnimation(.easeInOut(duration: 0.25)) {
                    showDescription.toggle()
                  }
                } label: {
                  HStack(spacing: 4) {
                    Text(showDescription ? "Hide Description" : "Show Description")
                      .font(.subheadline)
                      .foregroundColor(.white)
                    Image(systemName: showDescription ? "chevron.up" : "chevron.down")
                      .font(.system(size: 10, weight: .semibold))
                      .foregroundColor(.white.opacity(0.8))
                  }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.white.opacity(0.15))
                .clipShape(Capsule())
                
                ZStack {
                  if showDescription {
                    let (segments, _) = MarkdownRenderer.render(description)
                    VStack(alignment: .leading, spacing: 0) {
                      ForEach(0..<segments.count, id: \.self) { i in
                        segments[i]
                      }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                    .transition(.scale(scale: 0.90, anchor: .top))
                    .animation(.easeOut(duration: 0.2), value: showDescription)
                  }
                }
                .clipped()
              }
            }
            
            Divider()
            
            //            Text("Architecture").font(.headline)
            // MARK: ARCHITECTURE TABLE INFO
            let columns = [
              GridItem(.flexible(), alignment: .leading),
              GridItem(.flexible(), alignment: .leading),
              GridItem(.flexible(), alignment: .leading)
            ]
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 6) {
              // Header row
              Text("Input").font(.subheadline).fontWeight(.semibold)
              Text("Output").font(.subheadline).fontWeight(.semibold)
              Text("Tokenizer").font(.subheadline).fontWeight(.semibold)
              
              // Single row with all input modalities in one HStack
              HStack(spacing: 4) {
                ForEach(model.architecture.inputModalities, id: \.self) { input in
                  Image(systemName: input == "text" ? "text.alignleft" : input == "image" ? "photo" : input == "file" ? "doc" : input == "audio" ? "waveform" : "questionmark")
                }
              }
              
              // Single row with all output modalities in one HStack
              HStack(spacing: 4) {
                ForEach(model.architecture.outputModalities, id: \.self) { output in
                  Image(systemName: output == "text" ? "text.alignleft" : output == "image" ? "photo" : output == "file" ? "doc" : output == "audio" ? "waveform" : "questionmark")
                }
              }
              
              // Tokenizer text
              Text(model.architecture.tokenizer)
                .font(.body)
                .fontWeight(.medium)
            }
            .padding(.horizontal, 5)
            
            // Optional instruct type
            if let instructType = model.architecture.instructType {
              Text("Instruct Type: \(instructType)")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 4)
            }
            
            Divider()
            
            // MARK: TOP PROVIDER info
            let topProviderColumns = [
              GridItem(.flexible(minimum: 90, maximum: .infinity), alignment: .leading),
              GridItem(.flexible(), alignment: .leading),
              GridItem(.flexible(), alignment: .leading)
            ]
            
            LazyVGrid(columns: topProviderColumns, alignment: .leading, spacing: 6) {
              Text("Context Length").font(.subheadline).fontWeight(.semibold)
              Text("Max Tokens").font(.subheadline).fontWeight(.semibold)
              Text("Moderated").font(.subheadline).fontWeight(.semibold)
              
              if let contextLength = model.topProvider.contextLength {
                Text(humanReadableNumber(contextLength))
              } else {
                Text("N/A")
              }
              if let maxTokens = model.topProvider.maxCompletionTokens {
                Text(humanReadableNumber(maxTokens))
              } else {
                Text("N/A")
              }
              HStack(spacing: 4) {
                Image(systemName: model.topProvider.isModerated ? "lock.shield.fill" : "shield.slash.fill")
                  .foregroundColor(.white)
                Text(model.topProvider.isModerated ? "Yes" : "No")
              }
            }
            
            Divider()
            
            // MARK: Pricing visual
            HStack {
              Text("Pricing").font(.headline)
                .padding(.trailing, 16)
              
              MultiToggle(
                options: perTokenPricingOptions,
                selected: $perTokenCount,
                fontSize: 12,
                optionHeight: 18,
                padding: 2
              )
            }
            LazyVStack(alignment: .leading, spacing: 5) {
              
              let promptPrice = perTokenCount * (model.pricing.promptValue ?? 0)
              pricingRow(label: "Prompt", value: promptPrice)
              let completionPrice = perTokenCount * (model.pricing.completionValue ?? 0)
              pricingRow(label: "Completion", value: completionPrice)
              let imagePrice = perTokenCount * (model.pricing.imageValue ?? 0)
              pricingRow(label: "Image", value: imagePrice)
              let requestPrice = perTokenCount * (model.pricing.requestValue ?? 0)
              pricingRow(label: "Request", value: requestPrice)
              let webSearchPrice = perTokenCount * (model.pricing.webSearchValue ?? 0)
              pricingRow(label: "Web Search", value: webSearchPrice)
              let internalReasoningPrice = perTokenCount * (model.pricing.internalReasoningValue ?? 0)
              pricingRow(label: "Internal Reasoning", value: internalReasoningPrice)
              if let _ = model.pricing.inputCacheRead {
                let inputCachePrice = perTokenCount * (model.pricing.inputCacheReadValue ?? 0)
                pricingRow(label: "Input Cache Read", value: inputCachePrice)
              }
              if let _ = model.pricing.inputCacheWrite {
                let outputCachePrice = perTokenCount * (model.pricing.inputCacheWriteValue ?? 0)
                pricingRow(label: "Output Cache Write", value: outputCachePrice)
              }
            }
            
            // MARK: DEFAULT PARAMETERS
            if let params = model.defaultParameters,
               params.temperature != nil
                || params.topP != nil
                || params.frequencyPenalty != nil {
              Divider()
              Text("Default Parameters").font(.headline)
              if let temp = params.temperature { Text("Temperature: \(temp)") }
              if let topP = params.topP { Text("Top P: \(topP)") }
              if let freq = params.frequencyPenalty { Text("Frequency Penalty: \(freq)") }
            }
            
//            Divider()
//
//            if let slug = model.canonicalSlug { Text("Canonical Slug: \(slug)") }
//            if let context = model.contextLength { Text("Context Length: \(context)") }
//            if let hfId = model.huggingFaceId { Text("Hugging Face ID: \(hfId)") }
//
//            if let limits = model.perRequestLimits {
//              Text("Per Request Limits:").bold()
//              ForEach(limits.keys.sorted(), id: \.self) { key in
//                Text("\(key): \(limits[key] ?? 0)")
//              }
//            }
//
//            if let supported = model.supportedParameters {
//              Text("Supported Parameters: \(supported.joined(separator: ", "))")
//            }
          }
          .padding(.horizontal, 12)
        }
        .padding(.vertical, 12)
        .background(.white.opacity(0.05))
        .cornerRadius(12)
      } else {
        Text("No model selected").foregroundColor(.gray)
      }
    }
  }
  
  private func humanReadableNumber(_ n: Double) -> String {
    func format(_ value: Double) -> String {
      if value.truncatingRemainder(dividingBy: 1) == 0 {
        return String(format: "%.0f", value)
      } else {
        return String(format: "%.1f", value)
      }
    }
    
    if n >= 1_000_000_000 {
      return "\(format(n / 1_000_000_000))B"
    } else if n >= 1_000_000 {
      return "\(format(n / 1_000_000))M"
    } else if n >= 1_000 {
      return "\(format(n / 1_000))K"
    } else {
      return format(n)
    }
  }
  
  private func pricingRow(label: String, value: Double) -> some View {
    if value != 0 {
      let formattedValue: String = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 10
        formatter.usesGroupingSeparator = false
        if let string = formatter.string(from: NSNumber(value: value)) {
          // Remove trailing zeros beyond two decimals if any
          if let dotIndex = string.firstIndex(of: ".") {
            let decimals = string[string.index(after: dotIndex)...]
            var trimmedDecimals = decimals
            // Trim trailing zeros but keep at least two decimals
            while trimmedDecimals.count > 2 && trimmedDecimals.last == "0" {
              trimmedDecimals = trimmedDecimals.dropLast()
            }
            return String(string[..<string.index(after: dotIndex)]) + trimmedDecimals
          } else {
            // No decimal point, add .00
            return string + ".00"
          }
        } else {
          return String(format: "%.2f", value)
        }
      }()
      return AnyView(
        HStack(spacing: 6) {
          Text(label)
          Spacer()
          Text("$\(formattedValue)")
            .frame(alignment: .trailing)
        }
      )
    } else {
      return AnyView(EmptyView())
    }
  }
  
  private let perTokenPricingOptions: [ToggleOption<Double>] = [
    ToggleOption(id: 1_000, label: "1K"),
    ToggleOption(id: 100_000, label: "100K"),
    //    ToggleOption(id: 250_000, label: "250K"),
    ToggleOption(id: 1_000_000, label: "1M"),
    ToggleOption(id: 1_000_000_000, label: "1B"),
  ]
}

#Preview {
  @Previewable @State var model: OpenRouterModel? = OpenRouterModel.exampleModel
  ModelPreview($model)
    .frame(width: 300, height: 600)
}
