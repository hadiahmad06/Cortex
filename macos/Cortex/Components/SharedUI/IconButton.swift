//
//  IconButton.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/13/25.
//

import SwiftUI

struct IconButton<Content: View>: View {
  let systemName: String?
  var foregroundColor: Color
  var action: () -> Void
  @Binding var isToggled: Bool
  var tooltip: String?
  var help: String?
  var size: CGFloat
  var fontSize: CGFloat
  var preserveAspectRatio: Bool
  
  let content: () -> Content
  
  @State private var isHovered = false
    
  init(
    systemName: String? = nil,
    foregroundColor: Color = .white.opacity(0.65),
    action: @escaping () -> Void = {},
    isToggled: Binding<Bool>,
    tooltip: String? = nil,
    help: String? = nil,
    size: CGFloat = 32,
    fontSize: CGFloat = 18,
    preserveAspectRatio: Bool = true,
    @ViewBuilder content: @escaping () -> Content = { EmptyView() }
  ) {
    self.systemName = systemName
    self.foregroundColor = foregroundColor
    self.action = action
    self._isToggled = isToggled
    self.tooltip = tooltip
    self.help = help
    self.size = size
    self.fontSize = fontSize
    self.preserveAspectRatio = preserveAspectRatio
    self.content = content
  }
  
  var body: some View {
    Button(action: {
        isToggled.toggle()
        action()
    }) {
      Group {
        if let systemName = systemName {
          Image(systemName: systemName)
        } else {
          content()
        }
      }
        .font(.system(size: fontSize))
        .foregroundColor(foregroundColor)
        .modifier(FixedFrameModifier(size: size, applyFrame: preserveAspectRatio))
        .background(
          isToggled ? Color.blue.opacity(0.5) :
          (isHovered ? Color.white.opacity(0.075) : Color.clear)
        )
        .cornerRadius(6)
    }
    .buttonStyle(PlainButtonStyle())
    .help(tooltip ?? systemName ?? "")
    .accessibilityLabel(help ?? tooltip ?? systemName ?? "")
    .onHover { hovering in
      isHovered = hovering
    }
  }
}

struct FixedFrameModifier: ViewModifier {
  let size: CGFloat
  let applyFrame: Bool
  
  func body(content: Content) -> some View {
    if applyFrame {
      content.frame(width: size, height: size)
    } else {
      content.frame(minWidth: size, minHeight: size)
    }
  }
}
