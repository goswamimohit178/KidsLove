//
//  MatchManager.swift
//  KidsLove
//
//  Created by Vikash on 13/03/23.
//

import Foundation
import GameKit

class MatchManager: NSObject {
    var match: GKMatch?
    var otherplayer: GKPlayer?
    var localPlayer = GKLocalPlayer.local
    
    var layerUUIDKey = UUID().uuidString
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    func startMatchMaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let matchMakingVC = GKMatchmakerViewController(matchRequest: request)
        matchMakingVC?.matchmakerDelegate = self
        rootViewController?.present(matchMakingVC!, animated: true)
    }
    func startGame(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherplayer = match?.players.first
        
    }
}
