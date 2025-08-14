//
//  PromptButton.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/13/25.
//


import SwiftUI

struct PromptButton: View {
    let systemName: String
    var foregroundColor: Color = .white
    var action: () -> Void = {}
    @Binding var isToggled: Bool?  // optional binding
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            if isToggled != nil {
                isToggled!.toggle()
            }
            action()
        }) {
            Image(systemName: systemName)
                .font(.system(size: 18))
                .foregroundColor(foregroundColor)
                .frame(width: 32, height: 32)
                .background(
                    (isToggled ?? false) ? Color.blue.opacity(0.5) :
                    (isHovered ? Color.white.opacity(0.05) : Color.clear)
                )
                .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
