//
//  TutorialView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/11/25.
//

import SwiftUI

struct TutorialView: View {
  @EnvironmentObject var tutorial: TutorialManager
  @EnvironmentObject var settings: SettingsManager
  
  @State var child: (any TutorialStepView)? = nil
  @State var error: String? = nil
  
  private func viewFor(_ step: TutorialStep?) -> (any TutorialStepView)? {
    switch step {
    case .addKey:
      return TutorialAPIKeyView(
        settings: settings,
        error: $error
      )
    case .chatBasics:
      return EmptyTutorialView()
    case .clearingChats:
      return TutorialAPIKeyView(
        settings: settings,
        error: $error
      )
    case .limits:
      return EmptyTutorialView()
    case .modelSwitching:
      return TutorialAPIKeyView(
        settings: settings,
        error: $error
      )
    default:
      return EmptyTutorialView()
    }
  }
  
  var body: some View {
    VStack(spacing: 20) {
      if let child = self.child {
        child.erased
      }
        
      HStack(spacing: 16) {
        PromptButton(
          title: "Skip",
          action: {
            if let child = self.child {
              if child.skipValidation() {
                tutorial.complete(step: child.step)
              }
            }
          },
          foregroundColor: .primary,
          backgroundColor: Color.gray.opacity(0.2)
        )

        PromptButton(
          title: "Next",
          action: {
            if let child = self.child {
              if child.nextValidation() {
                tutorial.complete(step: child.step)
              }
            }
          }
        )
      }
    }
    .frame(maxWidth: 400)
    .padding(16)
    .background(.ultraThinMaterial)
    .cornerRadius(24)
    .shadow(radius: 20)
    .transition(.scale)
    
    .onAppear {
      self.child = viewFor(.addKey)//manager.nextIncompleteStep())
    }
  }
}

protocol TutorialStepView {
  var step: TutorialStep { get }

  /// Actions that the step knows how to perform
  func nextValidation() -> Bool
  func skipValidation() -> Bool
  
  var erased: AnyView { get }
}

private struct EmptyTutorialView: TutorialStepView, View {
  var step: TutorialStep = .addKey // or a dummy step
  func nextValidation() -> Bool { return true }
  func skipValidation() -> Bool { return true }
  var erased: AnyView { AnyView(self) }
  
  var body: some View {
    EmptyView()
  }
}

// Optional preview
struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
            .frame(width: 600, height: 300)
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}

