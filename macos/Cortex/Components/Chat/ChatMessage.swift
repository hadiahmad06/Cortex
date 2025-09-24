//
//  ChatMessage.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/14/25.
//

import SwiftUI

struct ChatMessage: View {
  var msg: Message
  
  private func safeMarkdown(_ text: String) -> [MarkdownSegment] {
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
  
  private func getMarkdown(_ markdown: String, text: String) -> [MarkdownSegment] {
      var segments: [MarkdownSegment] = []
      let parts = markdown.components(separatedBy: "```")
      
      for (index, part) in parts.enumerated() {
          if index % 2 == 1 {
              // Odd indices = inside fenced code
              segments.append(.codeBlock(part.trimmingCharacters(in: .whitespacesAndNewlines)))
          } else {
              // Even indices = normal markdown (may contain inline code)
              do {
                  let attributed = try AttributedString(
                      markdown: part,
                      options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
                  )
                  var buffer = AttributedString()

                  for run in attributed.runs {
                      if run.inlinePresentationIntent == .code {
                          // Flush any buffered text before code
                          if !buffer.characters.isEmpty {
                              segments.append(.text(buffer))
                              buffer = AttributedString()
                          }
                          
                          let codeText = String(attributed[run.range].characters)
                          segments.append(.inlineCode(codeText))
                      } else {
                          // Add this run’s text into the buffer
                          buffer += AttributedString(attributed[run.range])
                      }
                  }

                  // Flush remaining text
                  if !buffer.characters.isEmpty {
                      segments.append(.text(buffer))
                  }
              } catch {
                  segments.append(.text(AttributedString(part)))
              }
          }
      }
      
      return segments
  }
  
  var renderedSegments: [AnyView] {
    var segments: [AnyView] = []
    var buffer = AttributedString()
    for segment in getMarkdown(msg.text, text: msg.text) {
      switch segment {
      case .text(let attributed):
          buffer += attributed
      case .inlineCode(let code):
          buffer += AttributedString("`\(code)`")
      case .codeBlock(let codeText):
        if !buffer.characters.isEmpty {
          segments.append(AnyView(
            Text(buffer)
              .foregroundColor(.white.opacity(0.75))
              .padding(.vertical, 6)
              .padding(.horizontal, msg.isUser ? 12 : 0)
              .background(msg.isUser ? .white.opacity(0.15) : .clear)
              .cornerRadius(msg.isUser ? 16 : 0)
              .frame(maxWidth: .infinity, alignment: msg.isUser ? .trailing : .leading)
          ))
          buffer = AttributedString()
        }
        segments.append(AnyView(CodeBlockView(code: codeText)))
      }
    }
    if !buffer.characters.isEmpty {
        segments.append(AnyView(
          Text(buffer)
            .foregroundColor(.white.opacity(0.75))
            .padding(.vertical, 6)
            .padding(.horizontal, msg.isUser ? 12 : 0)
            .background(msg.isUser ? .white.opacity(0.15) : .clear)
            .cornerRadius(msg.isUser ? 16 : 0)
            .frame(maxWidth: .infinity, alignment: msg.isUser ? .trailing : .leading)
        ))
      }
      return segments
  }
  
  var body: some View {
    VStack(alignment: msg.isUser ? .trailing : .leading, spacing: 0) {
      HStack {
        if msg.isUser {
          Spacer()
        }
        VStack(alignment: .leading, spacing: 0) {
          ForEach(0..<renderedSegments.count, id: \.self) { i in
            renderedSegments[i]
          }
        }
        if !msg.isUser {
          Spacer()
        }
      }
    }
  }
}
