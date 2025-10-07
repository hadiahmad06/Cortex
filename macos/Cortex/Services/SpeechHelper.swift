//
//  SpeechHelper.swift
//  Cortex
//
//  Created by Hadi Ahmad on 9/22/25.
//


import AVFoundation

class SpeechHelper: NSObject, ObservableObject {
  static let shared = SpeechHelper()
  
  private(set) var synthesizer = AVSpeechSynthesizer()
  @Published var isSpeaking: Bool = false
  
  private override init() {
    super.init()
    synthesizer.delegate = self
  }
  
  func speak(_ text: String) {
    if synthesizer.isSpeaking {
      stop()
    }
    let utterance = AVSpeechUtterance(string: text)
    
    if let voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact") {
        utterance.voice = voice
    } else {
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    }

    utterance.rate = 0.5
    synthesizer.speak(utterance)
  }
  
  func stop() {
    synthesizer.stopSpeaking(at: .immediate)
  }
}

extension SpeechHelper: AVSpeechSynthesizerDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    isSpeaking = true
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    isSpeaking = false
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
    isSpeaking = false
  }
}
