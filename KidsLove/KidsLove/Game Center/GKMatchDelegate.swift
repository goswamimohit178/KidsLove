//
//  GKMatchDelegate.swift
//  KidsLove
//
//  Created by Vikash on 13/03/23.
//

import Foundation
import GameKit
extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        recevedDataAction?(data)
        let str = String(decoding: data, as: UTF8.self)
        print(str)
    }

    func sendstring(_ message: String) {
        guard let encoded = "strData:\(message)".data(using: .utf8 ) else{ return }
        sendData(encoded, mode: .reliable)
    }
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try match?.sendData(toAllPlayers:  data, with: mode)
        } catch {
            print(error)
        }
    }
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {

    }

}
