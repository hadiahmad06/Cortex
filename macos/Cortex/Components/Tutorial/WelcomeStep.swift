//
//  WelcomeStep.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/13/25.
//

import SwiftUI

struct WelcomeStep: View, TutorialStepView {
    // MARK: - TutorialStepView conformance
  var step: TutorialStep = .welcome

  func nextValidation() -> Bool {
      true
  }

  func skipValidation() -> Bool {
      true
  }

  var erased: AnyView { AnyView(self) }

  // MARK: - View body
  var body: some View {
    VStack(spacing: 24) {
        // App name bold, large, modern, white
        Text("Mirage")
            .font(.system(size: 48, weight: .heavy, design: .default)) // default = straight, modern
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
        
        // Tagline
        Text("Your smart companion for effortless organization")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.white.opacity(0.8))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
        
        // Tutorial invitation
        Text("Let’s take a quick tour to get you started! 🚀")
            .font(.body)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
    }
    .padding(32)
  }
}


#Preview {
  WelcomeStep()
}
