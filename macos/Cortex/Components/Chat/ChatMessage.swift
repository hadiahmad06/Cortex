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
              // Preprocess lines for headers and line breaks, but do not split normal markdown on \n for AttributedString parsing
              let lines = part.split(separator: "\n", omittingEmptySubsequences: false)
              var currentIndex = part.startIndex
              var lastProcessedIndex = currentIndex
              var foundSpecialLine = false
              
              for line in lines {
                  let lineRange = currentIndex..<part.index(currentIndex, offsetBy: line.count)
                  let trimmedLine = part[lineRange].trimmingCharacters(in: .whitespaces)
                  
                  if trimmedLine == "---" {
                      // Flush any accumulated text before line break
                      let textRange = lastProcessedIndex..<lineRange.lowerBound
                      if textRange.lowerBound < textRange.upperBound {
                          let textSegment = String(part[textRange])
                          do {
                              let attributed = try AttributedString(
                                  markdown: textSegment,
                                  options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
                              )
                              var buffer = AttributedString()
                              for run in attributed.runs {
                                  if run.inlinePresentationIntent == .code {
                                      if !buffer.characters.isEmpty {
                                          segments.append(.text(buffer))
                                          buffer = AttributedString()
                                      }
                                      let codeText = String(attributed[run.range].characters)
                                      segments.append(.inlineCode(codeText))
                                  } else {
                                      buffer += AttributedString(attributed[run.range])
                                  }
                              }
                              if !buffer.characters.isEmpty {
                                  segments.append(.text(buffer))
                              }
                          } catch {
                              segments.append(.text(AttributedString(textSegment)))
                          }
                      }
                      segments.append(.lineBreak)
                      lastProcessedIndex = part.index(lineRange.upperBound, offsetBy: 1, limitedBy: part.endIndex) ?? part.endIndex
                      foundSpecialLine = true
                  } else if let headerMatch = trimmedLine.range(of: #"^(#{1,6})\s"#, options: .regularExpression) {
                      // Flush any accumulated text before header
                      let textRange = lastProcessedIndex..<lineRange.lowerBound
                      if textRange.lowerBound < textRange.upperBound {
                          let textSegment = String(part[textRange])
                          do {
                              let attributed = try AttributedString(
                                  markdown: textSegment,
                                  options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
                              )
                              var buffer = AttributedString()
                              for run in attributed.runs {
                                  if run.inlinePresentationIntent == .code {
                                      if !buffer.characters.isEmpty {
                                          segments.append(.text(buffer))
                                          buffer = AttributedString()
                                      }
                                      let codeText = String(attributed[run.range].characters)
                                      segments.append(.inlineCode(codeText))
                                  } else {
                                      buffer += AttributedString(attributed[run.range])
                                  }
                              }
                              if !buffer.characters.isEmpty {
                                  segments.append(.text(buffer))
                              }
                          } catch {
                              segments.append(.text(AttributedString(textSegment)))
                          }
                      }
                      let headerHashes = String(trimmedLine[headerMatch])
                      let level = headerHashes.filter { $0 == "#" }.count
                      let headerTextStartIndex = trimmedLine.index(headerMatch.upperBound, offsetBy: 0)
                      let headerText = String(trimmedLine[headerTextStartIndex...])
                      do {
                          let attributedHeaderText = try AttributedString(markdown: headerText, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))
                          segments.append(.header(level: level, text: attributedHeaderText))
                      } catch {
                          segments.append(.header(level: level, text: AttributedString(headerText)))
                      }
                      lastProcessedIndex = part.index(lineRange.upperBound, offsetBy: 1, limitedBy: part.endIndex) ?? part.endIndex
                      foundSpecialLine = true
                  }
                  currentIndex = part.index(lineRange.upperBound, offsetBy: 1, limitedBy: part.endIndex) ?? part.endIndex
              }
              
              if !foundSpecialLine {
                  // No headers or line breaks found, parse whole part at once
                  do {
                      let attributed = try AttributedString(
                          markdown: part,
                          options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
                      )
                      var buffer = AttributedString()
                      for run in attributed.runs {
                          if run.inlinePresentationIntent == .code {
                              if !buffer.characters.isEmpty {
                                  segments.append(.text(buffer))
                                  buffer = AttributedString()
                              }
                              let codeText = String(attributed[run.range].characters)
                              segments.append(.inlineCode(codeText))
                          } else {
                              buffer += AttributedString(attributed[run.range])
                          }
                      }
                      if !buffer.characters.isEmpty {
                          segments.append(.text(buffer))
                      }
                  } catch {
                      segments.append(.text(AttributedString(part)))
                  }
              } else {
                  // There were headers or line breaks, flush remaining text after last special line
                  if lastProcessedIndex < part.endIndex {
                      let remainingText = String(part[lastProcessedIndex..<part.endIndex])
                      do {
                          let attributed = try AttributedString(
                              markdown: remainingText,
                              options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
                          )
                          var buffer = AttributedString()
                          for run in attributed.runs {
                              if run.inlinePresentationIntent == .code {
                                  if !buffer.characters.isEmpty {
                                      segments.append(.text(buffer))
                                      buffer = AttributedString()
                                  }
                                  let codeText = String(attributed[run.range].characters)
                                  segments.append(.inlineCode(codeText))
                              } else {
                                  buffer += AttributedString(attributed[run.range])
                              }
                          }
                          if !buffer.characters.isEmpty {
                              segments.append(.text(buffer))
                          }
                      } catch {
                          segments.append(.text(AttributedString(remainingText)))
                      }
                  }
              }
          }
      }
      
      return segments
  }
  
  var renderedSegments: ([AnyView], Bool) {
    var isInlineOnly: Bool = true
    var segments: [AnyView] = []
    var buffer = AttributedString()
    for segment in getMarkdown(msg.text, text: msg.text) {
      switch segment {
      case .text(let attributed):
          buffer += attributed
      case .inlineCode(let code):
          buffer += AttributedString("`\(code)`")
      case .codeBlock(let codeText):
        isInlineOnly = false
        if !buffer.characters.isEmpty {
          segments.append(AnyView(
            Text(buffer)
              .foregroundColor(.white.opacity(0.75))
              .padding(.vertical, 6)
          ))
          buffer = AttributedString()
        }
        segments.append(AnyView(
          CodeBlockView(code: codeText)
            .frame(maxWidth: .infinity, alignment: .leading)
        ))
      case .header(let level, let text):
        if !buffer.characters.isEmpty {
          segments.append(AnyView(
            Text(buffer)
              .foregroundColor(.white.opacity(0.75))
              .padding(.vertical, 6)
          ))
          buffer = AttributedString()
        }
        segments.append(AnyView(
          Text(text)
            .font(level == 1 ? .largeTitle : (level == 2 ? .title : (level == 3 ? .title2 : (level == 4 ? .headline : (level == 5 ? .subheadline : .footnote)))))
            .bold()
            .foregroundColor(.white.opacity(0.85))
            .padding(.vertical, 4)
        ))
      case .lineBreak:
        if !buffer.characters.isEmpty {
          segments.append(AnyView(
            Text(buffer)
              .foregroundColor(.white.opacity(0.75))
              .padding(.vertical, 6)
          ))
          buffer = AttributedString()
        }
        segments.append(AnyView(
          Divider()
            .foregroundColor(Color.white.opacity(0.65))
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        ))
      }
    }
    if !buffer.characters.isEmpty {
        segments.append(AnyView(
          Text(buffer)
            .foregroundColor(.white.opacity(0.75))
            .padding(.vertical, 6)
        ))
      }
      return (segments, isInlineOnly)
  }
  
  var body: some View {
    
    VStack(alignment: msg.isUser ? .trailing : .leading, spacing: 0) {
      HStack {
        if msg.isUser { Spacer() }
        let (segments, isInlineOnly) = self.renderedSegments
        VStack(alignment: .leading, spacing: 0) {
          ForEach(0..<segments.count, id: \.self) { i in
            segments[i]
              .padding(.horizontal, (msg.isUser && isInlineOnly) ? 12 : 0)
              .background((msg.isUser && isInlineOnly) ? .green.opacity(0.15) : .clear)
          }
        }
        .padding(.horizontal, (msg.isUser && !isInlineOnly) ? 12 : 0)
        .background((msg.isUser && !isInlineOnly) ? .red.opacity(0.15) : .clear)
        .cornerRadius(msg.isUser ? 16 : 0)
        .frame(maxWidth: msg.isUser ? 600 : .infinity, alignment: msg.isUser ? .trailing : .leading)
        if !msg.isUser { Spacer() }
      }
    }
  }
}
