//
//  CortexApp.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import SwiftUI

@main
struct CortexApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.titleBar) // use .hiddenTitleBar for minimal
        .defaultSize(width: 600, height: 400)
    }
}
