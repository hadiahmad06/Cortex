//
//  WindowAccessor.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/28/25.
//


import SwiftUI

extension View {
    func onWindow(_ callback: @escaping (NSWindow) -> Void) -> some View {
        background(WindowAccessor(callback: callback))
    }
}

private struct WindowAccessor: NSViewRepresentable {
    let callback: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                callback(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}