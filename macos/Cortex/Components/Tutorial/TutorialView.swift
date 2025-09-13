//
//  TutorialView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/11/25.
//

import SwiftUI

struct TutorialView: View {
  @EnvironmentObject var manager: TutorialManager
  @EnvironmentObject var settings: TutorialManager
  
  @State var child: (any TutorialStepView)? = nil //{
//    didSet {
//      self.childView = child?.erased
//    }
//  }
//  @State var childView: AnyView? = nil
  
  private func viewFor(_ step: TutorialStep?) -> (any TutorialStepView)? {
    switch step {
    case .addKey:
      return TutorialAPIKeyView()
    case .chatBasics:
      return EmptyTutorialView()
    case .clearingChats:
      return TutorialAPIKeyView()
    case .limits:
      return EmptyTutorialView()
    case .modelSwitching:
      return TutorialAPIKeyView()
    default:
      return EmptyTutorialView()
    }
  }
  
  var body: some View {
    VStack(spacing: 20) {
      if let child = child {
        child.erased
      }
      
      if let child = child {
        HStack(spacing: 16) {
          PromptButton(
            title: "Skip",
            action: {
              if child.skipValidation() { manager.complete(step: child.step) }
            },
            foregroundColor: .primary,
            backgroundColor: Color.gray.opacity(0.2)
          )

          PromptButton(
            title: "Next",
            action: {
              if child.nextValidation() {
                print("NEXT TUTORIAL STEP!!")
                manager.complete(step: child.step) }
            }
          )
        }
//        .padding(.top, 10)
      }
    }
    .frame(maxWidth: 400)
//    .padding()
//    .background(.ultraThinMaterial)
//    .cornerRadius(16)
//    .shadow(radius: 20)
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

