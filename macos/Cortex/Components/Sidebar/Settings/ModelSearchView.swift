//
//  ModelSearchView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 10/3/25.
//

import SwiftUI

struct ModelSearchView: View {
  @EnvironmentObject var settings: SettingsManager
  
  @State var isExpanded: Bool = false
  @State var currPreview: String? = nil
  
  @State var searchResults: [OpenRouterModel] = []
  @State private var searchText: String = ""
  @FocusState private var isFocused: Bool
  
//  @State var showInfoToggle: Bool = false
  
  @State var error: Error? = nil
  
  var body: some View {
    VStack {
      // MARK: NO SAVED MODELS
      if let error = error {
        VStack(spacing: 8) {
          Spacer()
          Text("Network Error")
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.white.opacity(0.6))
          Text(error.localizedDescription)
            .font(.system(size: 12, weight: .light))
            .foregroundColor(.white.opacity(0.6))
          Spacer()
        }
        .padding(.horizontal, 12)
      } else if (searchText.isEmpty && settings.settings.savedModels.isEmpty) {
        Spacer()
        Text("No Saved Models")
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(.white.opacity(0.6))
          .padding()
      } else {
        ScrollView(.vertical) {
          HStackWrapped(spacingX: 8, spacingY: 6) {
            if !searchText.isEmpty && searchResults.isEmpty {
              //   Show skeleton placeholders
              ForEach(0..<7, id: \.self) { i in
                TimelineView(.animation(minimumInterval: 0.01, paused: false)) { timeline in
                  let t = timeline.date.timeIntervalSinceReferenceDate
                  let phase = Double(i) * 0.8
                  RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: CGFloat(60 + (10 * (i % 5))), height: 24)
                    .redacted(reason: .placeholder)
                    .opacity(CGFloat(0.6 + 0.25 * sin(t * 4 + phase)))
                }
              }
            } else {
              let pills =
              settings.settings.savedModels.isEmpty
              ? searchResults
              : settings.settings.savedModels
              ForEach(pills, id: \.id) { model in
                let selected = currPreview == model.id
                Button(action: {
                  currPreview = selected ? nil : model.id
                }) {
                  Text(model.name)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.vertical, 5)
                    .padding(.horizontal, 9)
                    .background(selected ? Color.accentColor.opacity(0.3): Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
              }
            }
          }
          .padding(.top, 16)
          .padding(.horizontal, 12)
        }
      }
      Spacer()
      HStack {
        HStack {
          Image(systemName: "magnifyingglass")
            .font(.system(size: 12))
            .frame(width: 22, height: 22)
            .background(Color.white.opacity(0.15))
            .cornerRadius(isFocused ? 12 : 8)
          TextField("Search models...", text: $searchText)
            .textFieldStyle(PlainTextFieldStyle())
            .focused($isFocused)
//          IconButton(
//            systemName: showInfoToggle ? "info.circle.fill" : "info",
//            action: OverlayWindowController.shared.toggle,
//            isToggled: $showInfoToggle,
//            tooltip: "Toggle to show more info on press",
//            help: showInfoToggle
//              ? "Press to save immediately on press"
//              : "Press to show more info on press",
//            size: 24,
//            fontSize: 14
//          )
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(Color.white.opacity(0.1))
        .cornerRadius(isFocused ? 16 : 10)
      }
      .padding(.bottom, 12)
      .padding(.horizontal, 12)
    }
    .background(Color.white.opacity(0.1))
    .cornerRadius(16)
    .frame(height: isExpanded ? 650 : 200)
    .onChange(of: searchText) { _, newValue in
      self.error = nil
      ModelSearchAPI.fetchModels(
        apiKey: settings.settings.openrouter_api_key,
        filters: ModelFilterSettings(search: newValue)
      ) { result in
        DispatchQueue.main.async {
          switch result {
          case .success(let models):
            searchResults = models
          case .failure(let error):
            self.error = error
            searchResults = []
          }
        }
      }
    }
  }
}

#if DEBUG
struct ModelPillSearchView_Previews: PreviewProvider {
  //  var settings: SettingsManager = SettingsManager()
  //  settings.settings.savedModels = ["GPT-4", "Claude 3", "LLaMA 2", "MPT-7B", "Falcon 40B"]
  static var previews: some View {
    ModelSearchView()
      .environmentObject(SettingsManager())
      .padding(20)
      .frame(width: 400, height: 600)
  }
}
#endif
