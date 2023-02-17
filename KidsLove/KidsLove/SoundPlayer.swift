//
//  File.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 17/02/23.
//

import Foundation
import AVFoundation
import UIKit

class ThemeManager {
    static var themeColor: UIColor {
        get {
            let hex = UserDefaults.standard.value(forKey: "themeColor") as? NSString
            return UIColor.colorWithHexString(hexString: hex) ?? UIColor(red: 0.443, green: 0.424, blue: 0.875, alpha: 1.0)
        }
        set {
            print(newValue)
            let hex = newValue.hexStringFromColor()
            return UserDefaults.standard.set(hex, forKey: "themeColor")
        }
    }
    
    static var theme: String? {
        get {
            return (UserDefaults.standard.value(forKey: "theme") as? String)
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "theme")
        }
    }
}

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


extension UIColor {
    func hexStringFromColor() -> NSString {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return NSString(string: hexString)
     }

    static func colorWithHexString(hexString: NSString?) -> UIColor? {
        guard let hexString = hexString else { return nil }
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()

        print(colorString)
        let alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    static func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt32 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        print(floatValue)
        return floatValue
    }

}
