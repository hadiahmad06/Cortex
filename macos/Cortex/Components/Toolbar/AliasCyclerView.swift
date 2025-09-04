//
//  AliasCyclerView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/3/25.
//

import SwiftUI

struct AliasCyclerView: View {
    let aliases: [String]
    @State private var selectedIndex: Int = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
      ZStack {
          ForEach(aliases.indices, id: \.self) { idx in
              Text(aliases[idx])
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .opacity(idx == selectedIndex ? 1 : 0)
                .offset(y: idx == selectedIndex ? 0 : (idx < selectedIndex ? -30 : 30))
                .animation(.easeInOut(duration: 0.4), value: selectedIndex)
          }
      }
      .frame(height: 40)
      .mask(
          LinearGradient(
              gradient: Gradient(colors: [.clear, .black, .black, .clear]),
              startPoint: .top,
              endPoint: .bottom
          )
      )
      .onAppear {
          startTimer()
      }
      .onDisappear {
          stopTimer()
      }
    }
    
    private func opacity(for index: Int) -> Double {
        if index == selectedIndex {
            return 1.0
        } else {
            let distance = abs(index - selectedIndex)
            return max(0, 1 - Double(distance) * 0.5)
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            withAnimation {
                selectedIndex = (selectedIndex + 1) % aliases.count
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
  AliasCyclerView(aliases:
                    ["Neural Sage",
                     "Data Whisperer",
                     "Cortex Pilot",
                     "Pattern Weaver"])
  // 4o generated names i wish i could be this corny
}
