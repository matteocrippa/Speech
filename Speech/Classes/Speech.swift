import AVFoundation
import Foundation

/// Speech configuration struct
public class SpeechConfiguration {
    public var rate = 0.3
    public var pitch = 0.1
    public var volume = 0.1
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
        //utterance.rate = Float(configuration.rate)
        //utterance.pitchMultiplier = Float(configuration.pitch)
        //utterance.volume = Float(configuration.volume)
        var voice: AVSpeechSynthesisVoice!

        for availableVoice in AVSpeechSynthesisVoice.speechVoices(){
                if ((availableVoice.language == AVSpeechSynthesisVoice.currentLanguageCode()) &&
                    (availableVoice.quality == AVSpeechSynthesisVoiceQuality.enhanced)){ // If you have found the enhanced version of the currently selected language voice amongst your available voices... Usually there's only one selected.
                    voice = availableVoice
                    print("\(availableVoice.name) selected as voice for uttering speeches. Quality: \(availableVoice.quality.rawValue)")
                }
        }
        if let selectedVoice = voice { // if sucessfully unwrapped, the previous routine was able to identify one of the enhanced voices
                print("The following voice identifier has been loaded: ",selectedVoice.identifier)
        } else {
                utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode()) // load any of the voices that matches the current language selection for the device in case no enhanced voice has been found.
        }
        
        Debug.log(source: .map, text)
        
        synth.speak(utterance)
        
        return utterance
    }
    
    public func silence(seconds: Double) -> AVSpeechUtterance? {
        let utterance = AVSpeechUtterance()
        
        utterance.preUtteranceDelay = seconds
        
        Debug.log(source: .map, "silence of \(seconds) sec")

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
