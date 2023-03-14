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
    var navigationController: UINavigationController
    var layerUUIDKey = UUID().uuidString
    var recevedDataAction: ((Data)-> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func startMatchMaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let matchMakingVC = GKMatchmakerViewController(matchRequest: request)
        matchMakingVC?.matchmakerDelegate = self
        navigationController.present(matchMakingVC!, animated: true)
    }
    func startGame(newMatch: GKMatch) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameVC = storyboard.instantiateViewController(withIdentifier: "GameVC") as! GameVC
        self.recevedDataAction = gameVC.recevedDataAction
        gameVC.gameMode = .withPlayerOffline
        navigationController.pushViewController(gameVC, animated: true)
        match = newMatch
        match?.delegate = self
        otherplayer = match?.players.first
        sendstring("hello bro")
        
    }
}
