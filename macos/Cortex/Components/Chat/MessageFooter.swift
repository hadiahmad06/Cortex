//
//  MessageFooter.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/14/25.
//

import SwiftUI

struct MessageFooter: View {
  var msg: Message
  @State private var didCopy: Bool = false
  @StateObject private var speaker = SpeechHelper.shared
  
  var body: some View {
    HStack(spacing: 0) {
      
      // Use a simple array of button purpose strings
      let buttonPurposes: [String] = msg.isUser
      ? ["copy", /*"edit",*/ "readAloud"]
      : ["copy", "readAloud", /*"repeat", "share"*/]
      
      ForEach(buttonPurposes, id: \.self) { purpose in
        switch purpose {
        case "copy":
          IconButton(
            systemName: didCopy ? "checkmark" : "rectangle.portrait.on.rectangle.portrait",
            action: {
              let pasteboard = NSPasteboard.general
              pasteboard.clearContents()
              pasteboard.setString(msg.text, forType: .string)
              
              didCopy = true
              DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                didCopy = false
              }
            },
            isToggled: .constant(false),
            tooltip: "Copy Message",
            help: "Copy Message",
            size: 28,
            fontSize: 12
          )
        case "edit":
          IconButton(
            systemName: "pencil.line",
            action: {},
            isToggled: .constant(false),
            tooltip: "Edit Message",
            help: "Edit Message",
            size: 28,
            fontSize: 14
          )
        case "readAloud":
          IconButton(
            systemName: speaker.isSpeaking ? "stop.fill" : "speaker.wave.2.fill",
            action: {
              if speaker.isSpeaking {
                speaker.stop()
              } else {
                speaker.speak(msg.text)
              }
            },
            isToggled: .constant(false),
            tooltip: "Read Message Aloud",
            help: "Read Message Aloud",
            size: 28,
            fontSize: 12
          )
        case "repeat":
          IconButton(
            systemName: "repeat",
            action: {},
            isToggled: .constant(false),
            tooltip: "Repeat Response",
            help: "Repeat Response",
            size: 28,
            fontSize: 12
          )
        case "share":
          IconButton(
            systemName: "square.and.arrow.up",
            action: {},
            isToggled: .constant(false),
            tooltip: "Share Response",
            help: "Share Response",
            size: 28,
            fontSize: 12
          )
        default:
          EmptyView()
          fatalError("Unknown button purpose: \(purpose)")
        }
      }
    }
  }
}

#Preview {
  let msg = Message(id: UUID(), text: "That will silence the error and let your delegate callbacks fire correctly.", isUser: true)
  MessageFooter(msg: msg)
    .padding(16)
}
