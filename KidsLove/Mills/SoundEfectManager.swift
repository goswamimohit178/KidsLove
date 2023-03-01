//
//  SoundEfectManager.swift
//  Mills
//
//  Created by vishnu.d on 29/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import Foundation

import AVFoundation
import UIKit


class SoundEfectManager {
  private var player: AVAudioPlayer?
  
  func playSoundAlertFor(type: SoundAlertType) {
    var fileName: String?
    let generator = UINotificationFeedbackGenerator()
    switch type {
    case .notAllowed:
      fileName = "notAllowed"
      generator.notificationOccurred(.warning)
    case .bhar:
      fileName = "bhar"
      generator.notificationOccurred(.success)
    case .char:
      fileName = "char"
    case .move:
      fileName = "move"
    case .won:
      fileName = "win"
      generator.notificationOccurred(.success)
    case .lost:
      fileName = "lose"
      generator.notificationOccurred(.error)
    case .place:
      fileName = "place-player-1"
    case .select:
      fileName = "select"
    }
		
		guard !SoundPlayer.isMute else {
			return
		}
    
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
      fatalError("file must exists")
    }
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)

        /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

        /* iOS 10 and earlier require the following line:
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

        guard let player = player else { return }

        player.play()

    } catch let error {
        print(error.localizedDescription)
    }
  }
}
