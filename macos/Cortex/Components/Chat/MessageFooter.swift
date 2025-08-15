//
//  MessageFooter.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/14/25.
//

import SwiftUI

struct MessageFooter: View {
  var msg: Message
  
  @State private var isCopied: Bool? = false
  @State private var isReadAloud: Bool? = false
  @State private var isRegenerated: Bool? = false
  @State private var isPinned: Bool? = false
  @State private var isShared: Bool? = false
  @State private var isEdited: Bool? = false
  
  var body: some View {
    HStack {
      if msg.isUser {
        Spacer()
      }
      
      // Use a simple array of button purpose strings
      let buttonPurposes: [String] = msg.isUser
      ? ["copy", "edit", "readAloud"]
      : ["copy", "readAloud", "repeat", "share"]
      
      ForEach(buttonPurposes, id: \.self) { purpose in
        switch purpose {
        case "copy":
          IconButton(
            systemName: "rectangle.portrait.on.rectangle.portrait",
            action: {},
            isToggled: $isCopied,
            tooltip: "",
            help: "",
            size: 20,
            fontSize: 12
          )
        case "edit":
          IconButton(
            systemName: "pencil.line",
            action: {},
            isToggled: $isEdited,
            tooltip: "",
            help: "",
            size: 20,
            fontSize: 14
          )
        case "readAloud":
          IconButton(
            systemName: "speaker.wave.2.fill",
            action: {},
            isToggled: $isReadAloud,
            tooltip: "",
            help: "",
            size: 20,
            fontSize: 12
          )
        case "repeat":
          IconButton(
            systemName: "repeat",
            action: {},
            isToggled: $isRegenerated,
            tooltip: "",
            help: "",
            size: 20,
            fontSize: 12
          )
        case "share":
          IconButton(
            systemName: "square.and.arrow.up",
            action: {},
            isToggled: $isShared,
            tooltip: "",
            help: "",
            size: 20,
            fontSize: 12
          )
        default:
          EmptyView()
          fatalError("Unknown button purpose: \(purpose)")
        }
      }
      
      if !msg.isUser {
        Spacer()
      }
    }
  }
}
