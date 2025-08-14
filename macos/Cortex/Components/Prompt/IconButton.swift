//
//  IconButton.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/13/25.
//


import SwiftUI

struct IconButton: View {
    let systemName: String
    var foregroundColor: Color = .white.opacity(0.65)
    var action: () -> Void = {}
    @Binding var isToggled: Bool?  // optional binding
    var tooltip: String?
    var help: String?
    var size: CGFloat = 32
    var fontSize: CGFloat = 18
    
  
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            if isToggled != nil {
                isToggled!.toggle()
            }
            action()
        }) {
            Image(systemName: systemName)
                .font(.system(size: fontSize))
                .foregroundColor(foregroundColor)
                .frame(width: size, height: size)
                .background(
                    (isToggled ?? false) ? Color.blue.opacity(0.5) :
                    (isHovered ? Color.white.opacity(0.075) : Color.clear)
                )
                .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
        .help(tooltip ?? systemName)
        .accessibilityLabel(help ?? tooltip ?? systemName)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
