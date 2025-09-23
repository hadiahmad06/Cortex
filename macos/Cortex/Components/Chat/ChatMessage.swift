//
//  ChatMessage.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/14/25.
//

import SwiftUI

struct ChatMessage: View {
  var msg: Message
  
  private func safeMarkdown(_ text: String) -> AttributedString {
    var markdown = text

    // --- Code fences (``` … ```)
    let codeBlockCount = markdown.components(separatedBy: "```").count - 1
    if codeBlockCount % 2 != 0 {
      markdown += "\n```"
    }

    // --- Inline code (` … `)
    let inlineCount = markdown.components(separatedBy: "`").count - 1
    if inlineCount % 2 != 0 {
      markdown += "`"
    }

    // --- Bold (** … **)
    let boldCount = markdown.components(separatedBy: "**").count - 1
    if boldCount % 2 != 0 {
      markdown += "**"
    }

    // --- Italic (* … *)
    let italicCount = markdown.components(separatedBy: "*").count - 1
    if italicCount % 2 != 0 {
      markdown += "*"
    }

    // --- Strikethrough (~~ … ~~)
    let strikeCount = markdown.components(separatedBy: "~~").count - 1
    if strikeCount % 2 != 0 {
      markdown += "~~"
    }

    // --- Link brackets ([ … ])
    let openBrackets = markdown.components(separatedBy: "[").count - 1
    let closeBrackets = markdown.components(separatedBy: "]").count - 1
    if openBrackets > closeBrackets {
      markdown += "]"
    }

    // --- Link parentheses (( … ))
    let openParens = markdown.components(separatedBy: "(").count - 1
    let closeParens = markdown.components(separatedBy: ")").count - 1
    if openParens > closeParens {
      markdown += ")"
    }
    
    return getMarkdown(markdown, text: text)
  }
  
  private func getMarkdown(_ markdown: String, text: String) -> AttributedString {
    // Parse Markdown safely
    var attributed: AttributedString
    do {
      attributed = try AttributedString(
        markdown: markdown,
        options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
      )
    } catch {
      attributed = AttributedString(text)
    }
    
    // Style runs
    for run in attributed.runs {
      // Check for inline code
      if run.inlinePresentationIntent == .code {
          attributed[run.range].font = .system(.body, design: .monospaced)
          attributed[run.range].backgroundColor = .gray.opacity(0.15)
          attributed[run.range].foregroundColor = .white
      }
        
        // Handle headers - macOS compatible approach
      if let intent = run.presentationIntent {
        // For macOS compatibility: check if it's a heading
        for component in intent.components {
          switch component.kind {
          case .header(let level):
            switch level {
            case 1:
              attributed[run.range].font = .system(size: 22, weight: .bold)
            case 2:
              attributed[run.range].font = .system(size: 20, weight: .semibold)
            case 3:
              attributed[run.range].font = .system(size: 18, weight: .medium)
            case 4:
              attributed[run.range].font = .system(size: 16, weight: .medium)
            case 5:
              attributed[run.range].font = .system(size: 14, weight: .medium)
            case 6:
              attributed[run.range].font = .system(size: 12, weight: .medium)
            default:
              break
            }
          default:
            break
          }
        }
      }
        
      // Bold
      if run.inlinePresentationIntent == .stronglyEmphasized {
        attributed[run.range].font = .system(.body, weight: .bold)
      }
      
      // Italic
      if run.inlinePresentationIntent == .emphasized {
        attributed[run.range].font = .system(.body).italic()
      }
      
      // Strikethrough
      if run.inlinePresentationIntent == .strikethrough {
        attributed[run.range].strikethroughStyle = .single
        attributed[run.range].strikethroughColor = .red//.opacity(0.8)
      }
      
      // Links
      if let link = run.link {
        attributed[run.range].foregroundColor = .blue
        attributed[run.range].underlineStyle = .single
      }
    }
    
    return attributed
  }
  
  var body: some View {
    VStack(alignment: msg.isUser ? .trailing : .leading, spacing: 0) {
      HStack {
        if msg.isUser {
          Spacer()
          Text(safeMarkdown(msg.text))
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(.white.opacity(0.15))
            .foregroundColor(.white.opacity(0.75))
            .cornerRadius(16)
        } else {
          Text(safeMarkdown(msg.text))
            .padding(.vertical, 6)
            .foregroundColor(.white.opacity(0.75))
            .frame(maxWidth: .infinity, alignment: .leading)
          Spacer()
        }
      }
    }
  }
}
