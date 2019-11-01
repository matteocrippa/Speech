//
//  File.swift
//  Pods
//
//  Created by Matteo Crippa on 30/05/2017.
//
//

import AVFoundation
import Foundation

/// Debug Verbosity
public enum DebugVerbosity {
  case none
  case all
  case error
  case message
}

/// Speech configuration struct
open class SpeechConfiguration {
  var rate: Float = 0.3
  var pitch: Float = 0.1
  var volume: Float = 0.1
  var debug: DebugVerbosity = .none
}

open class Speech: NSObject {
  
  /// Shared instance
  open static var shared = Speech()
  private override init() {}
  
  /// Configuration
  var configuration: SpeechConfiguration = SpeechConfiguration()
  
  /// Speech handler
  fileprivate let synth = AVSpeechSynthesizer()
  fileprivate var isSpeaking = false

  
  /// Speak function
  ///
  /// - Parameter text: text to be readed by voice
  public func speak(text: String) {
    
    // force delegate
    synth.delegate = self
    
    // if it's still speaking do nothing
    if isSpeaking == true {
      debug(error: "is already speaking")
      return
    }

    let utterance = AVSpeechUtterance(string: text)
    
    // set configuration
    utterance.rate = configuration.rate
    utterance.pitchMultiplier = configuration.pitch
    utterance.volume = configuration.volume
    
    debug(data: text)
    
    synth.speak(utterance)
    
    isSpeaking = true

  }
}

// MARK: - AVSpeechDeleagate
extension Speech: AVSpeechSynthesizerDelegate {
  public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    isSpeaking = false
  }
}

// MARK: - Logs
extension Speech {
  /// Error debug log wrapper for speech
  ///
  /// - Parameter error: string error
  fileprivate func debug(error: String) {
      if configuration.debug == .all || configuration.debug == .error {
        print("🗣❌ Speech Error ❌ > " + error)
      }
  }
  
  /// Action debug log wrapper for speech
  ///
  /// - Parameter data: string
  fileprivate func debug(data: String) {
      if configuration.debug == .all || configuration.debug == .message {
        print("🗣👉 Speech > " + data)
      }
  }
  
  /// Action settings log wrapper for db
  ///
  /// - Parameter data: string
  fileprivate func settings(data: String) {
      if configuration.debug == .all || configuration.debug == .message || configuration.debug == .error {
        print("🗣🎚 Speech > " + data)
      }
  }
}
