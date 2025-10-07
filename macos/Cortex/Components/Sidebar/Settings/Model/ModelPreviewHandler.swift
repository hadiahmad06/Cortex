//
//  ModelPreviewHandler.swift
//  Cortex
//
//  Created by Hadi Ahmad on 10/7/25.
//


import SwiftUI

struct ModelPreviewHandler: View {
  let hoveredModelId: String?
  let previewedModelId: String?
  
  @State private var hoveredModel: OpenRouterModel?
  @State private var previewedModel: OpenRouterModel?
  @EnvironmentObject var settings: SettingsManager
  
  init(hoveredModelId: String?, previewedModelId: String?) {
    self.hoveredModelId = hoveredModelId
    self.previewedModelId = previewedModelId
    // Initialize state from cache in the init
    _hoveredModel = State(initialValue: hoveredModelId != nil ? ModelSearchAPI.availableModelsCache[hoveredModelId!] : nil)
    _previewedModel = State(initialValue: previewedModelId != nil ? ModelSearchAPI.availableModelsCache[previewedModelId!] : nil)
  }
  
  var body: some View {
    Group {
      if let _ = hoveredModelId {
        ModelPreview(
          model: $hoveredModel,
          showDescription: $settings.settings.showPreviewDescription,
          perTokenCount: $settings.settings.perTokenCount
        )
      } else if let _ = previewedModelId {
        ModelPreview(
          model: $previewedModel,
          showDescription: $settings.settings.showPreviewDescription,
          perTokenCount: $settings.settings.perTokenCount
        )
      }
    }
    .onAppear {
      // Try to fetch hoveredModel if not in cache
      if let hoveredId = hoveredModelId, hoveredModel == nil {
        if let cached = ModelSearchAPI.availableModelsCache[hoveredId] {
          hoveredModel = cached
        } else {
          ModelSearchAPI.fetchModel(id: hoveredId) { model in
            DispatchQueue.main.async {
              if hoveredModelId == hoveredId {
                hoveredModel = model
              }
            }
          }
        }
      }
      // Try to fetch previewedModel if not in cache
      if let previewedId = previewedModelId, previewedModel == nil {
        if let cached = ModelSearchAPI.availableModelsCache[previewedId] {
          previewedModel = cached
        } else {
          ModelSearchAPI.fetchModel(id: previewedId) { model in
            DispatchQueue.main.async {
              if previewedModelId == previewedId {
                previewedModel = model
              }
            }
          }
        }
      }
    }
    .onChange(of: hoveredModelId) { _, newId in
      if let id = newId {
        if let cached = ModelSearchAPI.availableModelsCache[id] {
          hoveredModel = cached
        } else {
          hoveredModel = nil
          ModelSearchAPI.fetchModel(id: id) { model in
            DispatchQueue.main.async {
              if hoveredModelId == id {
                hoveredModel = model
              }
            }
          }
        }
      } else {
        hoveredModel = nil
      }
    }
    .onChange(of: previewedModelId) { _, newId in
      if let id = newId {
        if let cached = ModelSearchAPI.availableModelsCache[id] {
          previewedModel = cached
        } else {
          previewedModel = nil
          ModelSearchAPI.fetchModel(id: id) { model in
            DispatchQueue.main.async {
              if previewedModelId == id {
                previewedModel = model
              }
            }
          }
        }
      } else {
        previewedModel = nil
      }
    }
  }
}
