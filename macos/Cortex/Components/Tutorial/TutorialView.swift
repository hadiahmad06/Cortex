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
  
//  @State var child: (any TutorialStepView)? = nil
  @State var error: String? = nil
  
  var child: (any TutorialStepView)? {
    viewFor(tutorial.currentStep)
  }
  
  private func viewFor(_ step: TutorialStep?) -> (any TutorialStepView)? {
    switch step {
    case .welcome:
      return WelcomeStep()
    case .addKey:
      return APIKeyStep(
        settings: settings,
        error: $error
      )
    case .limits:
      return LimitsStep(
        settings: settings
      )
    default:
      return nil
    }
  }
  
  var body: some View {
    if let child = self.child {
      Color.black.opacity(0.4)
      VStack(spacing: 20) {
        if let child = self.child {
          child.erased
        }
        
        HStack(spacing: 16) {
          PromptButton(
            title: "Skip",
            action: {
//              if let child = self.child {
                if child.skipValidation() {
                  tutorial.complete(step: child.step)
                }
//              }
            },
            foregroundColor: .primary,
            backgroundColor: Color.gray.opacity(0.2)
          )
          
          PromptButton(
            title: "Next",
            action: {
//              if let child = self.child {
                if child.nextValidation() {
                  tutorial.complete(step: child.step)
                  error = nil
                }
//              }
            }
          )
        }
      }
//      .frame(maxWidth: 400)
      .padding(16)
      .background(.ultraThinMaterial)
      .cornerRadius(24)
      .shadow(radius: 20)
      .transition(.scale)
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
        .environmentObject(TutorialManager())
        .environmentObject(SettingsManager())
            .frame(width: 600, height: 300)
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}

