//
//  MinMaxAlgo.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 13/03/23.
//

import Foundation

// Define a class for the game board
//class MyBoard {
//    // Define the game board as a 3x3 array
//    var board = [[Int]](repeating: [Int](repeating: -1, count: 3), count: 3)
//
//    // Print the game board
//    func printBoard() {
//        for row in board {
//            print(row.joined())
//        }
//    }
//
//    // Check if a move is valid
//    func isValidMove(_ row: Int, _ col: Int) -> Bool {
//        return board[row][col] == -1
//    }
//
//    // Make a move
//    func makeMove(_ row: Int, _ col: Int, _ player: Int) {
//        board[row][col] = player
//    }
//
//    // Undo a move
//    func undoMove(_ row: Int, _ col: Int) {
//        board[row][col] = -1
//    }
//
//    // Check if the game is over
//    func isGameOver(_ player: Int) -> Bool {
//        // Check rows
//        for row in board {
//            if row == [player, player, player] {
//                return true
//            }
//        }
//        // Check columns
//        for i in 0..<3 {
//            if board[0][i] == player && board[1][i] == player && board[2][i] == player {
//                return true
//            }
//        }
//        // Check diagonals
//        if board[0][0] == player && board[1][1] == player && board[2][2] == player {
//            return true
//        }
//        if board[0][2] == player && board[1][1] == player && board[2][0] == player {
//            return true
//        }
//        return false
//    }
//
//    // Get the current state of the board
//    func getState() -> String {
//        var state = ""
//        for row in board {
//            state += row.joined()
//        }
//        return state
//    }
//    
//    func heuristicValue() -> Int {
//            // Calculate the heuristic value of the board state
//            // You can use any heuristic function that makes sense for your game
//            // This example simply returns a random value between -100 and 100
//            return Int.random(in: -100...100)
//        }
//
//    
//        // Constructor and other properties/methods of Board class
//        
//        func getValidMoves(for player: Int) -> [(from: Int, to: Int)] {
//            var moves: [(from: Int, to: Int)] = []
//            
//            // Check if the player has any pieces left to place on the board
//            if player == 1 && countPieces(on: board, for: player) < 3 {
//                // Player 1 has less than 3 pieces on the board, can place on any unoccupied spot
//                for i in 0..<board.count {
//                    for j in 0..<board[i].count {
//                        if board[i][j] == 0 {
//                            moves.append((from: -1, to: i * board.count + j))
//                        }
//                    }
//                }
//            } else {
//                // Player has 3 or more pieces on the board, can move to adjacent unoccupied spots
//                for i in 0..<board.count {
//                    for j in 0..<board[i].count {
//                        if board[i][j] == player {
//                            // Check all adjacent spots
//                            if i > 0 && board[i-1][j] == 0 {
//                                // Can move to the spot above
//                                moves.append((from: i * board.count + j, to: (i-1) * board.count + j))
//                            }
//                            if i < board.count - 1 && board[i+1][j] == 0 {
//                                // Can move to the spot below
//                                moves.append((from: i * board.count + j, to: (i+1) * board.count + j))
//                            }
//                            if j > 0 && board[i][j-1] == 0 {
//                                // Can move to the spot to the left
//                                moves.append((from: i * board.count + j, to: i * board.count + (j-1)))
//                            }
//                            if j < board[i].count - 1 && board[i][j+1] == 0 {
//                                // Can move to the spot to the right
//                                moves.append((from: i * board.count + j, to: i * board.count + (j+1)))
//                            }
//                        }
//                    }
//                }
//            }
//            
//            return moves
//        }
//        
//        // Helper function to count the number of pieces of a given player on the board
//        func countPieces(on board: [[Int]], for player: Int) -> Int {
//            var count = 0
//            for row in board {
//                for cell in row {
//                    if cell == player {
//                        count += 1
//                    }
//                }
//            }
//            return count
//        }
//    }



class MinimaxAlgo {
    
    
//    var finalDepth1 = 4
//    var finalDepth2 = 4
//    var finalDepth3 = 3
//    var nbrNoeuds = 0
//
//    func minimaxPhase1(state: [Int], depth: Int, isMax: Int, inIndex: Int, alpha: Int, beta: Int) -> Int {
//        let table = Board(state: state)
//
//        if depth == 1 {
//            if table.moulinformation(inIndex, -1, state) {
//                return 2000
//            }
//
//            if table.moulinformation(inIndex, 1, state) {
//                return 1000
//            }
//        }
//
//        if depth != 0 {
//            if table.moulinformation(inIndex, -1, state) {
//                return 400 / depth
//            }
//        }
//
//        if depth == finalDepth1 {
//            return (100 * table.heuristique(-1, state, 0) - 50 * table.heuristique(1, state, 0))
//        }
//
//        var scores = Array(repeating: -9999, count: 24)
//        var bestValue = isMax == 1 ? +10000000 : -10000000
//        var fils = [Int]()
//        var newState = state
//        for i in 0..<24 {
//            if newState[i] == 0 {
//                newState[i] = 1
//
//                if table.moulinformation(i, 1, newState) {
//                    for i in 0..<24 {
//                        if newState[i] == 0 && table.moulinformation(i, -1, newState) {
//                            var v = [Int]()
//                            table.voisin(i, &v, table.intersectionRemplie, -1)
//                            for it in v {
//                                table.intersectionRemplie[it] = 0
//                            }
//                            break
//                        }
//                    }
//                }
//
//                let son = minimaxPhase1(state: newState, depth: depth + 1, isMax: -1, inIndex: i, alpha: alpha, beta: beta)
//                fils.append(son)
//                newState[i] = 0
//                scores[i] = son
//                nbrNoeuds += 1
//
//                if isMax == 1 {
//                    bestValue = min(bestValue, son)
//                    beta = min(beta, bestValue)
//                    if beta < alpha {
//                        break
//                    }
//                } else if isMax == -1 {
//                    bestValue = max(bestValue, son)
//                    alpha = max(alpha, bestValue)
//                    if beta < alpha {
//                        break
//                    }
//                }
//            }
//        }
//
//        for j in 0..<24 {
//            if scores[j] == *fils.min() {
//                if depth == 0 {
//                    print("ma value : \(scores[j])")
//                    return j
//                } else {
//                    return scores[j]
//                }
//            }
//        }
//
//        return 0
//    }
    
   
//
}



//func minimax(state: MyBoard, depth: Int, maximizingPlayer: Bool, alpha: Int, beta: Int) -> Int {
//
//    if depth == 0 || state.isGameOver("1") {
//        return state.heuristicValue()
//    }
//
//    if maximizingPlayer {
//        var value = Int.min
//
//        for move in state.getValidMoves() {
//            let nextState = state.makeMove(move: move)
//            value = max(value, minimax(state: nextState, depth: depth-1, maximizingPlayer: false, alpha: alpha, beta: beta))
//            alpha = max(alpha, value)
//            if alpha >= beta {
//                break
//            }
//        }
//
//        return value
//
//    } else {
//        var value = Int.max
//
//        for move in state.getValidMoves() {
//            let nextState = state.makeMove(move: move)
//            value = min(value, minimax(state: nextState, depth: depth-1, maximizingPlayer: true, alpha: alpha, beta: beta))
//            beta = min(beta, value)
//            if alpha >= beta {
//                break
//            }
//        }
//
//        return value
//    }
//}
