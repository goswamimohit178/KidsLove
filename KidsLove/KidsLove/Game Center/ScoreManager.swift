//
//  ScoreManager.swift
//  KidsLove
//
//  Created by Vikash on 10/03/23.
//

import Foundation
import GameKit
class ScoreManager {
    let defaults = UserDefaults.standard
    
    func increaseScore(byValue: Int) {
        let oldScore = getPriviousScore()
        print("oldScore: \(oldScore)")
        let newScore = oldScore + byValue
        print("newScore: \(newScore)")
        setNewScore(newScore: newScore)
        submit(newScore: newScore)
        unlockAchievement(achievement: "additiondynamo")
    }
    
    private func getPriviousScore() -> Int{
        let keyForScore = "score"
        let priviousScore = defaults.value(forKey: keyForScore) as! Int
        return priviousScore
    }
    private func setNewScore(newScore: Int) {
        let keyForScore = "score"
        defaults.set(newScore, forKey: keyForScore)
    }
    private func submit(newScore: Int) {
        GKLeaderboard.submitScore(newScore, context:0, player: GKLocalPlayer.local, leaderboardIDs: ["smarterplayers"], completionHandler: {error in})
    }
    private func unlockAchievement(achievement: String) {
        let achievement = GKAchievement(identifier: achievement)
        achievement.percentComplete = 100
        achievement.showsCompletionBanner = true
        GKAchievement.report([achievement]) { error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            print("Done!")
        }
    }
    
}
