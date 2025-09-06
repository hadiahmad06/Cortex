//
//  MultiToggle.swift
//  Cortex
//
//  Derived from React Native Code
//  From Vectra (Side Project)
//  https://www.github.com/hadiahmad06/vectra
//  Hadi Ahmad
//

import SwiftUI

struct ToggleOption: Identifiable, Hashable {
  let id: String
  let label: String
  var disabled: Bool = false
}

struct MultiToggle: View {
  let options: [ToggleOption]
  @Binding var selected: String
  var accentColor: Color = Color.blue

  @Namespace private var animation
  private let padding: CGFloat = 4
  private let optionHeight: CGFloat = 30
  private let cornerRadius: CGFloat = 6

  @State private var shakeOffset: CGFloat = 0

  var body: some View {
    HStack(spacing: padding) {
      ForEach(options) { option in
        ZStack {
          // Slider only
          if selected == option.id {
            RoundedRectangle(cornerRadius: cornerRadius)
              .fill(accentColor)
              .matchedGeometryEffect(id: "slider", in: animation)
              .offset(x: shakeOffset) // only slider shakes
          }

          // Text
          Text(option.label)
            .fontWeight(.medium)
            .font(.system(size: 16))
            .foregroundColor(selected == option.id ? .white : .primary.opacity(option.disabled ? 0.4 : 1))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: optionHeight)
        .contentShape(Rectangle()) // now the whole option is tappable
        .onTapGesture {
          if !option.disabled {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
              selected = option.id
            }
          } else {
            shake()
          }
        }
      }
    }
    .padding(padding)
    .frame(height: optionHeight + padding * 2)
    .background(
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.2))
    )
  }

  // Simple shake effect using offset animation
  private func shake() {
    withAnimation(.linear(duration: 0.05)) { shakeOffset = 10 }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
      withAnimation(.linear(duration: 0.05)) { shakeOffset = -10 }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
          withAnimation(.linear(duration: 0.05)) { shakeOffset = 0 }
        }
      }
  }
}

struct MultiToggle_Previews: PreviewProvider {
  @State static var selected = "one"

  static var previews: some View {
    MultiToggle(
      options: [
        ToggleOption(id: "one", label: "One"),
        ToggleOption(id: "two", label: "Two"),
        ToggleOption(id: "three", label: "Three", disabled: true)
      ],
      selected: $selected,
      accentColor: .purple
    )
    .padding()
    .previewLayout(.sizeThatFits)
  }
}
