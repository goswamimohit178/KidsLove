//
//  MillsPlayer.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 13/03/23.
//

import Foundation
import Combine

class MillsPlayer: Equatable {
    static func == (lhs: MillsPlayer, rhs: MillsPlayer) -> Bool {
        lhs.playerNumber == rhs.playerNumber
    }
    
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
    
    @objc dynamic var currentBhars = [[Int]]()
    
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
    
    func getPositionToPlace(board: MillsBoard) -> Int {
        // This method must be overriden!
        return 0
    }
    
    func getPositionToMove(board: MillsBoard) -> (from: Int, to: Int) {
        // This method must be overriden!
        return (1, 24)
    }
    
    func charPosition() -> Int {
        // This method must be overriden!
        return 0
    }
}
