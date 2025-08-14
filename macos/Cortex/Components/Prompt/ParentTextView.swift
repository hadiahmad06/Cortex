//
//  ParentTextView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/14/25.
//

import SwiftUI

struct ParentTextView: View {
  @State private var measuredTextHeight: CGFloat = 30
  @Binding var inputTextBinding: String
  @Binding var isFirstResponder: Bool
  var onEnterPressed: () -> Void
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      if $inputTextBinding.wrappedValue.isEmpty {
        Text("Type a prompt…")
          .font(.system(size: 12))
          .foregroundColor(.white.opacity(0.4))
      }
      AutoGrowingTextView(
        text: $inputTextBinding,
        isFirstResponder: $isFirstResponder,
        measuredHeight: $measuredTextHeight,
        onEnterPressed: onEnterPressed,
        maxHeight: 120
      )
      .onTapGesture {
        //            NSApp.activate(ignoringOtherApps: true)
        //            isFirstResponder = true
      }
    }
    .frame(height: min(measuredTextHeight, 120))
    .padding(.top, 12)
    .padding(.horizontal, 16)
  }
}
