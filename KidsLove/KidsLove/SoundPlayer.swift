//
//  File.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 17/02/23.
//

import Foundation
import AVFoundation

class SoundPlayer {
   
    
    static var isMute: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "isMute") as? Bool) ?? false
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "isMute")
        }
    }
    
    var player: AVAudioPlayer?
    
    func playSound(soundString: String) {
        guard !SoundPlayer.isMute else { return }
        guard let path = Bundle.main.url(forResource: soundString, withExtension: "wav") else { return }

        let audioData = try! Data.init(contentsOf: path)
           do
           {
               let audioPlayer = try AVAudioPlayer.init(data: audioData) //Throwing error sometimes
               audioPlayer.delegate = self as? AVAudioPlayerDelegate
               audioPlayer.prepareToPlay()
               audioPlayer.play()

           } catch {
               print("An error occurred while trying to extract audio file")
           }
    }
}
