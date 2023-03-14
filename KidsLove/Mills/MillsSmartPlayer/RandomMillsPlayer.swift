//
//  RandomMillsPlayer.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 13/03/23.
//

import Foundation

class RandomMillsPlayer: MillsPlayer {
    override func getPositionToPlace(board: MillsBoard) -> Int {
        let possibleMoves = board.getPossiblePlacePositions()
        return possibleMoves.random!
    }
    
    override func getPositionToMove(board: MillsBoard) -> (from: Int, to: Int) {
        var positions = [(from: Int, to: Int)]()
        for position in playerPositions {
            let allEmptyNeighborPositions = board.allEmptyNeighborPositions(at: position)
            if !allEmptyNeighborPositions.isEmpty {
                positions.append((position, allEmptyNeighborPositions.first!))
            }
        }
        return positions.random!
    }
    
    override func charPosition() -> Int {
        var possibleCharPositions = [Int]()
        for position in board.opponentPlayer.playerPositions {
            if !board.opponentPlayer.isPositionInBhar(position: position) {
                possibleCharPositions.append(position)
            }
        }
        return possibleCharPositions.random!
    }
}
