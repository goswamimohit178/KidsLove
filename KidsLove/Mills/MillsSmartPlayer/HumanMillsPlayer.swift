//
//  HumanMillsPlayer.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 13/03/23.
//

import Foundation

class HumanMillsPlayer: MillsPlayer {
    override func getPositionToPlace(board: MillsBoard) -> Int {
        // this has to be done some other way.
        return 0
    }
    
    override func getPositionToMove(board: MillsBoard) -> (from: Int, to: Int) {
        return (1, 24)
    }
}
