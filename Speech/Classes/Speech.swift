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
public class SpeechConfiguration {
    public var rate = 0.3
    public var pitch = 0.1
    //public var volume = 0.1
    public var debug: DebugVerbosity = .none
}

public protocol SpeechDelegate: class {
    func finish(_ utterance: AVSpeechUtterance)
    func start(_ utterance: AVSpeechUtterance)
}

public class Speech: NSObject {
    
    /// Shared instance
    public static var shared = Speech()
    private override init() {
        super.init()
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: AVAudioSession.CategoryOptions.mixWithOthers)
            } else {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        // force delegate
        synth.delegate = self
    }
    
    /// Configuration
    public var configuration: SpeechConfiguration = SpeechConfiguration()
    public weak var delegate: SpeechDelegate?
    public var isSpeaking = false

    /// Speech handler
    fileprivate let synth = AVSpeechSynthesizer()
    
    
    /// Speak function
    ///
    /// - Parameter text: text to be readed by voice
    public func speak(text: String) -> AVSpeechUtterance? {
        
        let utterance = AVSpeechUtterance(string: text)
        
        // set configuration
        utterance.rate = Float(configuration.rate)
        utterance.pitchMultiplier = Float(configuration.pitch)
        utterance.volume = Float(configuration.volume)
        
        debug(data: text)
        
        synth.speak(utterance)
        
        return utterance
    }
    
    public func silence(seconds: Double) -> AVSpeechUtterance? {
        let utterance = AVSpeechUtterance()
        
        utterance.preUtteranceDelay = seconds
        
        debug(data: "silence of \(seconds) sec")

        return utterance
    }
}

// MARK: - AVSpeechDeleagate
extension Speech: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        delegate?.finish(utterance)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
        delegate?.start(utterance)
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
