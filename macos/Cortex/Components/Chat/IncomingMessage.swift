//
//  IncomingMessage.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/16/25.
//

import SwiftUI

struct IncomingMessage: View {
  @ObservedObject var chatSessionContext: ChatSessionContext
  @State private var timer: Timer? = nil
  
  var body: some View {
    let text = chatSessionContext.incomingMessageText
    
    HStack {
      Text(text)
        .padding(.vertical, 6)
        .foregroundColor(.white.opacity(0.75))
        .frame(alignment: .leading)
        .animation(.linear(duration: 0.1), value: text)
      Spacer()
    }
  }
}

//struct IncomingMessage_Previews: PreviewProvider {
//    struct StreamingPreview: View {
//        @State private var streamingText: String = ""
//        let fullMessage = "Hello! This is a streaming message. It will appear character by character to simulate an LLM response. Hello! This is a streaming message. It will appear character by character to simulate an LLM response. Hello! This is a streaming message. It will appear character by character to simulate an LLM response. Hello! This is a streaming message. It will appear character by character to simulate an LLM response. Hello! This is a streaming message. It will appear character by character to simulate an LLM response."
//        @State private var timer: Timer? = nil
//
//        var body: some View {
//            IncomingMessage(text: $streamingText)
//                .onAppear {
//                    streamingText = ""
//                    timer?.invalidate()
//                    var index = 0
//                    timer = Timer.scheduledTimer(withTimeInterval: 0.018, repeats: true) { t in
//                        if index < fullMessage.count {
//                            let nextChar = fullMessage[fullMessage.index(fullMessage.startIndex, offsetBy: index)]
//                            streamingText.append(nextChar)
//                            index += 1
//                        } else {
//                            t.invalidate()
//                        }
//                    }
//                }
//                .onDisappear {
//                    timer?.invalidate()
//                }
//        }
//    }
//    static var previews: some View {
//        StreamingPreview()
//    }
//}
