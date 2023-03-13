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
    
    
    func startMatchMaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let matchMakingVC = GKMatchmakerViewController(matchRequest: request)
        matchMakingVC?.matchmakerDelegate = self
    }
    func startGame(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherplayer = match?.players.first
        
    }
}
