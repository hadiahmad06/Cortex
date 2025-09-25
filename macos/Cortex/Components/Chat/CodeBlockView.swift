//
//  CodeBlockView.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/23/25.
//

import SwiftUI

enum MarkdownSegment {
  case text(AttributedString)
  case inlineCode(String)
  case codeBlock(String)
  case header(level: Int, text: AttributedString)
  case lineBreak
}

struct CodeBlockView: View {
  var code: String
  @State var didCopy: Bool = false
  
  var body: some View {
    VStack(spacing: 4) {
      HStack {
        Text("Code")
          .font(.caption).bold()
          .foregroundColor(.white.opacity(0.75))
        Spacer()
        IconButton(
          systemName: didCopy ? "checkmark" : "rectangle.portrait.on.rectangle.portrait",
          action: {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(code, forType: .string)
            
            didCopy = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              didCopy = false
            }
          },
          isToggled: .constant(false),
          tooltip: "Copy Message",
          help: "Copy Message",
          size: 22,
          fontSize: 11
        )
        IconButton(
          systemName: "arrow.up.left.and.arrow.down.right",
          action: {},
          isToggled: .constant(false),
          tooltip: "Expand Code Block",
          help: "Press to Expand Code Block",
          size: 22,
          fontSize: 11
        )
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 4)
      .background(.black.opacity(0.2))
      
      ScrollView(.horizontal, showsIndicators: false) {
        Text(code)
          .font(.system(.body, design: .monospaced))
          .foregroundColor(.white)
          .padding(8)
          .frame(maxWidth: .infinity)
      }
    }
    .background(.black.opacity(0.2))
    .cornerRadius(16)
    .padding(.vertical, 4)
  }
}
