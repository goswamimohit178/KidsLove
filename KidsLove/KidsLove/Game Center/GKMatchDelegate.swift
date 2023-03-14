//
//  GKMatchDelegate.swift
//  KidsLove
//
//  Created by Vikash on 13/03/23.
//

import Foundation
import GameKit

let delimiter = ":::"
let beginConst = "Begin"

extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let str = String(decoding: data, as: UTF8.self)
        let tokens = str.components(separatedBy: delimiter)
        let messageType = tokens[0]
        let matchPlayerID = tokens[1]
        if messageType == beginConst {
            handleBeginMessage(matchPlayerID: matchPlayerID)
        } else {
            recevedDataAction?(data)
        }
        print(str)
    }

    func sendString(_ message: String) {
        guard let encoded = message.data(using: .utf8 ) else{ return }
        sendData(encoded, mode: .reliable)
    }
    func sendData(_ data: Data, mode: GKMatch.SendDataMode = .reliable) {
        do {
            try match?.sendData(toAllPlayers:  data, with: mode)
        } catch {
            print(error)
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        guard state == .disconnected  else { return }
        let alert = UIAlertController(title: "Player Disconnected", message: "The player is disconnected from the game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.match?.disconnect()
            self.navigationController.popViewController(animated: true)
        })
        DispatchQueue.main.async {
            self.navigationController.present(alert, animated: true)
        }
    }
    
    func handleBeginMessage(matchPlayerID: String) {
        if matchPlayerID != self.playerModel.localPlayerID {
            self.playerModel.matchPlayerID = matchPlayerID
        } else {
            self.playerModel.localPlayerID = UUID().uuidString
            sendBeginMessage()
        }
    }
    
    func sendBeginMessage() {
        let message = "\(beginConst)\(delimiter)\(self.playerModel.localPlayerID)"
        sendString(message)
        print(message)
    }

}
