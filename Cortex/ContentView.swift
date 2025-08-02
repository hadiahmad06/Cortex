//
//  ContentView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    var body: some View {
        VStack {
            Text("Welcome to Cortex")
                .font(.largeTitle)
                .padding()

            Button("Summon Cortex") {
                OverlayWindowController.shared.toggle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            openWindow(id: OverlayView.id)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let window = NSApplication.shared.windows.first(where: { $0.identifier?.rawValue == OverlayView.id }) {
                    window.orderOut(nil)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
