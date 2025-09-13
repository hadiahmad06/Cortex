//
//  PromptButton.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/11/25.
//

import SwiftUI

struct PromptButton: View {
    let title: String
    let action: () -> Void
    var foregroundColor: Color = .white
    var backgroundColor: Color = .accentColor
    var cornerRadius: CGFloat = 12
    var horizontalPadding: CGFloat = 20
    var verticalPadding: CGFloat = 8

    @State private var isHovering = false

    var body: some View {
        Button(title, action: action)
            .buttonStyle(.plain)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor.opacity(isHovering ? 0.85 : 1))
            )
            .foregroundColor(foregroundColor)
            .onHover { hovering in
                isHovering = hovering
                NSCursor.pointingHand.set()
            }
            .animation(.easeInOut(duration: 0.15), value: isHovering)
    }
}
