//
//  MatchManager.swift
//  KidsLove
//
//  Created by Vikash on 13/03/23.
//

import Foundation
import GameKit

struct OnlinePlayerModel {
    var localPlayerName: String? = nil
    var localPlayerID = UUID().uuidString
    var matchPlayerID: String?
    var matchPlayerName: String? = nil
}

class MatchManager: NSObject {
    var match: GKMatch?
    var otherplayer: GKPlayer?
    var localPlayer = GKLocalPlayer.local
    var navigationController: UINavigationController
    var layerUUIDKey = UUID().uuidString
    var recevedDataAction: ((Data)-> Void)?

    var playerModel: OnlinePlayerModel {
        didSet {
            checkAndStartGame()
        }
    }
    
    init(navigationController: UINavigationController) {
        self.playerModel = OnlinePlayerModel()
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
    
    func matchedSuccessfully(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherplayer = match?.players.first
        playerModel.localPlayerName = localPlayer.displayName
        playerModel.matchPlayerName = otherplayer!.displayName
        self.sendBeginMessage()
    }
    
    func checkAndStartGame() {
        if playerModel.localPlayerName != nil, playerModel.matchPlayerName != nil, let matchPlayerID = playerModel.matchPlayerID, playerModel.localPlayerID != matchPlayerID {
            showGamesVC()
        }
    }
    
    func showGamesVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameVC = storyboard.instantiateViewController(withIdentifier: "GameVC") as! GameVC
        self.recevedDataAction = gameVC.recevedDataAction
        gameVC.gameMode = .withPlayerOnline(playerModel)
        gameVC.matchManager = self
        navigationController.pushViewController(gameVC, animated: true)
    }
}
