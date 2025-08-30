//
//  SidebarView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/29/25.
//

import SwiftUI

struct SidebarView: View {
  @State var searchText: String = ""
  var sessions: [(String, Date, UUID)]

  var body: some View {
    VStack {
      TextField("Search…", text: $searchText)
        .textFieldStyle(.roundedBorder)
        .padding(.top, 6)

      ScrollView {
        LazyVStack(alignment: .leading, spacing: 4) {
          let sortedSessions = sessions.sorted { $0.1 > $1.1 }
          ForEach(sortedSessions, id: \.2) { (title, date, id) in
            SessionRow(title: title, date: date)
          }
        }
      }
      .frame(maxWidth: 200, maxHeight: .infinity)

      SettingsButton()
    }
    .frame(maxWidth: 200, maxHeight: .infinity)
    .padding(.horizontal, 10)
    .background(Color.black.opacity(0.10))
  }
}
