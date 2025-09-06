//
//  HistoryView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/6/25.
//

import SwiftUI

struct HistoryView: View {
  @State var searchText: String = ""
  @ObservedObject var manager: ChatManager
  var body: some View {
    TextField("Search…", text: $searchText)
      .textFieldStyle(.roundedBorder)
      .padding(.top, 6)
    
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 4) {
        let sortedSessions = manager.sessionSummaries.sorted { $0.1 > $1.1 }
        ForEach(sortedSessions, id: \.2) { (title, date, id) in
          SessionRow(
            title: title,
            date: date,
            id: id,
            manager: manager
          )
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
