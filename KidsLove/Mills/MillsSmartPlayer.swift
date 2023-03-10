//
//  MillsSmartPlayer.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 05/03/23.
//

import Foundation
import Combine

class MillsPlayer {
    var playerNumber: Int
    var coinIcon: String
    
    var playerScoreModel: MillsAndAvailableCoin {
        didSet {
            passthroughSubject.send(playerScoreModel)
        }
    }
 var passthroughSubject: PassthroughSubject<MillsAndAvailableCoin, Never>

    unowned var board: MillsBoard
    var playerPositions: [Int] {
        var playerPositions = [Int]()
        for i in 1..<board.fields.count {
            if board.fields[i] == playerNumber {
                playerPositions.append(i)
            }
        }
        return playerPositions
    }
    
  @objc dynamic private var currentBhars = [[Int]]()

  @objc dynamic var isPlaying: Bool
  var playerRemainingPositions = DEFAULT_COIN_COUNT {
        didSet {
            self.playerScoreModel = MillsAndAvailableCoin(mills: playerScoreModel.mills, availableCoins: playerRemainingPositions)
        }
    }
  @objc dynamic var messageForUser: String
  @objc dynamic var animateMessage: Bool = true

  
  var isLost: Bool {
    guard playerRemainingPositions <= 0 else {
      return false
    }
    return (playerPositions.count+playerRemainingPositions)<=2
  }
  
  var isPlacedAllCoins: Bool {
    return (playerRemainingPositions == 0)
  }
  
  func place(at position: Int) {
      board.place(at: position, playerNumber: playerNumber)
  }
  
  func char(at position: Int) {
    playerScoreModel = playerScoreModel.increasingMills
    board.char(at: position, playerNumber: playerNumber)
    updateCurrentBhar()
  }
  
  func updateCurrentBhar() {
    currentBhars = currentBhars.filter { currentBhar in
      currentBhar.allSatisfy { bharPosition in
        playerPositions.contains(bharPosition)
      }
    }
  }
  
  func movePosition(from: Int, to: Int) {
    board.movePosition(from: from, to: to, playerNumber: playerNumber)
    updateCurrentBhar()
  }
  
    func checkBhar() -> [Int]? {
        var bharToReturn: [Int]?
        for bhar in allPossibleBhrs {
            let listSet = Set(playerPositions)
            let findListSet = Set(bhar)
            if findListSet.isSubset(of: listSet), !currentBhars.contains(bhar) {
                currentBhars.append(bhar)
                bharToReturn = bhar
            }
        }
        return bharToReturn
    }
    
    func checkBhar() -> Bool {
        var bharToReturn: [Int]?
        for bhar in allPossibleBhrs {
            let listSet = Set(playerPositions)
            let findListSet = Set(bhar)
            if findListSet.isSubset(of: listSet), !currentBhars.contains(bhar) {
                return true
            }
        }
        return false
    }
  
    func isPositionInBhar(position: Int) -> Bool {
        //dont check bhar if all are in bahar
        let allBhars = currentBhars.flatMap({$0})
        let allNonBharPosition = self.allNonBharPosition(allBhars: allBhars)
        guard !allNonBharPosition.isEmpty else {
            return false
        }
        return (allBhars.first { $0 == position } != nil)
    }
    
    func canCharAtPositions() -> [Int] {
        //dont check bhar if all are in bahar
        let allBhars = currentBhars.flatMap({$0})
        let allNonBharPosition = self.allNonBharPosition(allBhars: allBhars)
        guard !allNonBharPosition.isEmpty else {
            return allBhars
        }
        return allNonBharPosition
    }

    private func allNonBharPosition(allBhars: [Int]) -> [Int] {
        return playerPositions.filter { !allBhars.contains($0) }
    }
    
    func isOnly3Left() -> Bool {
        return (playerPositions.count == 3) && (playerRemainingPositions == 0)
    }
    
    func setPlaceOrMoveMessage() {
        if playerRemainingPositions > 0 {
            messageForUser = PlayerGuideMessages.getMessage(for: .place)
        } else {
            messageForUser = PlayerGuideMessages.getMessage(for: .selectForMove)
        }
    }
    
    init(playerNumber: Int, coinIcon: String, isPlaying: Bool, board: MillsBoard) {
        self.board = board
        self.isPlaying = isPlaying
        self.coinIcon = coinIcon
        self.playerNumber = playerNumber
        self.messageForUser = PlayerGuideMessages.getMessage(for: .place)
        self.passthroughSubject = PassthroughSubject()
        self.playerScoreModel = MillsAndAvailableCoin(mills: 0, availableCoins: 10)
    }
    
    func getMove(board: MillsBoard) -> Int {
        // This method must be overriden!
        return 0
    }
    
}

class RandomMillsPlayer: MillsPlayer {
    override func getMove(board: MillsBoard) -> Int {
        let possibleMoves = board.getPossibleMoves()
        let randomIndex = Int.random(in: 1..<possibleMoves.count)
        return possibleMoves[randomIndex]
    }
}

class HumanMillsPlayer: MillsPlayer {
    override func getMove(board: MillsBoard) -> Int {
        // this has to be done some other way.
        return 0
    }
}

class SmartMillsPlayer: MillsPlayer {
    override func getMove(board: MillsBoard) -> Int {
        let turn = board.getCurrentPlayer()
        var noLossMoves = [Int]()
        let possibleMoves = board.getPossibleMoves()
        if possibleMoves.count == 25 {
            return 1
        } else {
            // check winning move
            for row in possibleMoves {
                board.simulateMove(row: row, player: turn)
                if board.hasWon(playerNumber: turn) {
                    board.simulateMove(row: row, player: EMPTY_ROW_CONST)
                    print("Placed for wining")
                    return row
                }
                board.simulateMove(row: row, player: EMPTY_ROW_CONST)
            }
            // check prevent loss move
            for row in possibleMoves {
                var opponent = 1
                if turn == 1 {
                    opponent = 0
                }
                board.simulateMove(row: row, player: opponent)
                if board.hasWon(playerNumber: opponent) {
                    noLossMoves.append((row))
                }
                board.simulateMove(row: row, player: EMPTY_ROW_CONST)
            }
            if noLossMoves.count != 0 {
                print("Placed to prevent loss")
                return noLossMoves[0]
            }
          
            var possibleBharindex: Int? = nil
            allPossibleBhrs.forEach { bhar in
                let output = bhar.filter{ playerPositions.contains($0) }

                if output.count == 1 {
                    let emptyPositions = bhar.filter { pos in
                        return (board.fields[pos] == EMPTY_ROW_CONST)
                    }
                    if emptyPositions.count == 2 {
                        possibleBharindex = emptyPositions[0]
                    }
                }
            }
            
            if let possibleBharindex = possibleBharindex {
                return possibleBharindex
            }
            
            // return random move
            let randomIndex = Int.random(in: 1..<possibleMoves.count)
            print("Placed using random move")
            return possibleMoves[randomIndex]
        }
    }
}

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
        let possibleMoves = board.getPossibleMoves()
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
    
    override func getMove(board: MillsBoard) -> Int {
        //minor enhancement in the early stages of the game
        let possibleMoves = board.getPossibleMoves()
        if possibleMoves.count == 25 {
            return 1
        }
        
        player = board.getCurrentPlayer()
        opponent = (player == 0) ? 1 : 0
        if possibleMoves.count > 10 {
            return SmartMillsPlayer(playerNumber: player, coinIcon: "", isPlaying: true, board: board).getMove(board: board)
        }
        _ = minimax(board: board, depth: 0)
        if choice == 0 {
            let randomIndex = Int.random(in: 1..<possibleMoves.count)
            print("Placed using random move")
            choice = possibleMoves[randomIndex]
        }
        return choice
    }
}

