//
//  SmarterMillsPlayer.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 13/03/23.
//

import Foundation

class SmarterMillsPlayer: MillsPlayer {
    var player = -1
    var opponent = -1
    var choice = -1
    
    func evaluateGameState(board: MillsBoard, depth: Int) -> Int {
        // evaluate and return game state
        if board.hasWon(playerNumber: player) {
            return 10 - depth
        } else if board.hasWon(playerNumber: opponent) {
            return depth - 10
        } else {
            return 0
        }
    }
    
    func minimax(board: MillsBoard, depth: Int) -> Int {
        // minimax algorithm to not lose
        if board.isOver() {
            return evaluateGameState(board: board, depth: depth)
        }
        let dep = depth + 1
        var scores = [Int]()
        var moves = [Int]()
        let possibleMoves = board.getPossiblePlacePositions()
        // if divisible by two, that means it's player's turn. If not, it's the opponent's turn.
        let playersTurn = (depth % 2 == 0)
        
        for row in possibleMoves {
            // simulate move
            board.simulateMove(row: row, player: (playersTurn) ? player : opponent)
            // then, calculate the score of the board after making this move
            let score = minimax(board: board, depth: dep)
            scores.append(score)
            moves.append(row)
            // delete move again
            board.simulateMove(row: row, player: EMPTY_ROW_CONST)
        }
        
        // return the minimum or maximum score (depending on whether its the players turn or the opponents)
        let index = scores.index(of: (playersTurn) ? scores.max()! : scores.min()!)!
        choice = moves[index]
        let score =  (playersTurn) ? scores.max()! : scores.min()!
        print(score)
        return score
    }
    
    override func getPositionToPlace(board: MillsBoard) -> Int {
        //minor enhancement in the early stages of the game
        let possibleMoves = board.getPossiblePlacePositions()
        if possibleMoves.count == 25 {
            return 1
        }
        
        player = board.getCurrentPlayer()
        opponent = (player == 0) ? 1 : 0
        if possibleMoves.count > 10 {
            return SmartMillsPlayer(playerNumber: player, coinIcon: "", isPlaying: true, board: board).getPositionToPlace(board: board)
        }
        _ = minimax(board: board, depth: 0)
        if choice == 0 {
            print("Placed using random move")
            choice = possibleMoves.random!
        }
        return choice
    }
    
    override func getPositionToMove(board: MillsBoard) -> (from: Int, to: Int) {
        return (1, 24)
    }
}
