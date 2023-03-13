//
//  MillsBoard.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 10/03/23.
//

import Foundation
import Combine

enum Result {
    case playerWon
    case opponentWon
    case draw
    case undecided
}

let allPossibleBhrs = [
    [1,2,3],
    [4,5,6],
    [7,8,9],
    [10,11,12],
    [13,14,15],
    [16,17,18],
    [19,20,21],
    [22,23,24],
    [1,10,22],
    [4,11,19],
    [7,12,16],
    [2,5,8],
    [17,20,23],
    [9,13,18],
    [6,14,21],
    [3,15,24]
]

let neighborMap: [Int: [Int]] =
[1:[2,10],
 2:[5,1,3],
 3:[2,15],
 4:[11,5],
 5:[2,4,6,8],
 6:[14,5],
 7:[12,8],
 8:[7,5,9],
 9:[8,13],
 10:[1,11,22],
 11:[4,10,12,19],
 12:[7,11,16],
 13:[9,18,14],
 14:[13,6,15,21],
 15:[3,14,24],
 16:[12,17],
 17:[16,18,20],
 18:[17,13],
 19:[11,20],
 20:[17,19,21,23],
 21:[14,20],
 22:[10,23],
 23:[20,22,24],
 24:[15,23]]

var EMPTY_ROW_CONST = -1

class MillsBoard {
    var players = [MillsPlayer]()
    var fields: [Int]
    var coinIcon: String
    var passthroughSubject: PassthroughSubject<MillsAndAvailableCoin, Never>
    @objc dynamic var messageForUser: String
    @objc dynamic var animateMessage: Bool = true
    @objc dynamic private var currentBhars = [[Int]]()
    
    var current: Int
    var getOpponent: Int {
        if self.current == 0 {
            return 1
        } else {
            return 0
        }
    }
    
    init(fields: [Int]? = nil, current: Int = 0) {
        self.fields = fields ?? Array(repeating: EMPTY_ROW_CONST, count: 25)
        self.current = current
        self.coinIcon = "Icon1"
        self.messageForUser = PlayerGuideMessages.getMessage(for: .place)
        self.passthroughSubject = PassthroughSubject()
    }
    
    func printBoard() {
        for i in 1..<fields.count {
            print("\(i):---]\(fields[i])")
        }
    }
    
    func getField(row: Int) -> Int {
        return self.fields[row]
    }
    
    func getCurrentPlayer() -> Int {
        return self.current
    }
    
    func simulateMove(row: Int, player: Int) {
        self.fields[row] = player
        //        printBoard()
    }
    
    func makeMove(row: Int) {
        self.fields[row] = self.current
        self.current = getOpponent
    }
    
    func hasWon(playerNumber: Int) -> Bool {
        let player = players[playerNumber]
        let opponentPlayer = players[getOpponent]
        return player.checkBhar() || opponentPlayer.isLost
    }
    
    func isFull() -> Bool {
        for row in 1...24 {
            if self.fields[row] == EMPTY_ROW_CONST {
                return false
            }
        }
        return true
    }
    
    func getResult() -> Result {
        if self.hasWon(playerNumber: 0) {
            return .playerWon
        } else if self.hasWon(playerNumber: 1) {
            return .opponentWon
        } else if self.isFull() {
            return .draw
        } else {
            return .undecided
        }
    }
    
    func isOver() -> Bool {
        return (self.getResult() != .undecided)
    }
    
    func getPossiblePlacePositions() -> [Int] {
        var possibleMoves = [Int]()
        for i in 1..<fields.count {
            if self.fields[i] == EMPTY_ROW_CONST {
                possibleMoves.append(i)
            }
        }
        return possibleMoves
    }
    
    func place(at position: Int, playerNumber: Int) {
        makeMove(row: position)
    }
    
    func char(at position: Int, playerNumber: Int) {
        fields[position] = EMPTY_ROW_CONST
    }
    
    func movePosition(from: Int, to: Int, playerNumber: Int) {
        fields[from] = EMPTY_ROW_CONST
        makeMove(row: to)
    }
    
    var currentPlayer: MillsPlayer {
        return players[current]
    }
    
    var opponentPlayer: MillsPlayer {
        return players[getOpponent]
    }
    
    func checkIfAlreadyOccupied(position: Int) -> Bool {
      return currentPlayer.playerPositions.contains(position) || opponentPlayer.playerPositions.contains(position)
    }
    
    func canMove(from: Int, to position: Int) -> Bool {
      guard !checkIfAlreadyOccupied(position: position) else {
        return false
      }
      if currentPlayer.playerPositions.count == 3 {
              return true
          }
      return isNeighbor(from: from, to: position)
     }
    
    func isNeighbor(from: Int, to: Int) -> Bool {
      return neighborMap[from]!.contains(to)
    }
      
    func areNeighborsEmpty(at: Int) -> Bool {
        let allEmptyNeighborPositions = self.allEmptyNeighborPositions(at: at)
          return !allEmptyNeighborPositions.isEmpty
    }

    func allEmptyNeighborPositions(at: Int, for player: MillsPlayer? = nil) -> [Int] {
        let player = player ?? currentPlayer
          guard !player.isOnly3Left() else {
              return allEmptyPositions()
          }
          return neighborMap[at]!.filter { position in
              !currentPlayer.playerPositions.contains(position) && !opponentPlayer.playerPositions.contains(position)
          }
      }
      
      private func allEmptyPositions() -> [Int] {
          let allOccupied = currentPlayer.playerPositions + opponentPlayer.playerPositions
          return (1...24).filter { !allOccupied.contains($0) }
      }
}
