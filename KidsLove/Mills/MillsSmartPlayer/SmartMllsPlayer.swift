//
//  SmartMllsPlayer.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 13/03/23.
//

import Foundation

class SmartMillsPlayer: MillsPlayer {
    func possiblePlacePositionsToMakeBhar(turn: Int) -> [Int] {
        var positions = [Int]()
        let possibleMoves = board.getPossiblePlacePositions()
        for row in possibleMoves {
            board.simulateMove(row: row, player: turn)
            if board.hasWon(playerNumber: turn) {
                positions.append(row)
            }
            board.simulateMove(row: row, player: EMPTY_ROW_CONST)
        }
        return positions
    }
    
    override func getPositionToPlace(board: MillsBoard) -> Int {
        let turn = board.getCurrentPlayer()
        var noLossMoves = [Int]()
        let possibleMoves = board.getPossiblePlacePositions()
        if possibleMoves.count == 25 {
            return 1
        } else {
            // check winning move
            let possiblePlacePositionsToMakeBhar = possiblePlacePositionsToMakeBhar(turn: turn)
            if !possiblePlacePositionsToMakeBhar.isEmpty {
                return possiblePlacePositionsToMakeBhar.random!
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
            print("Placed using random move")
            return possibleMoves.random!
        }
    }
    
    func posibleBhars(player: MillsPlayer) -> [(from: Int, to: Int)] {
        var positions = [(from: Int, to: Int)]()
        for position in player.playerPositions {
            let allEmptyNeighborPositions = board.allEmptyNeighborPositions(at: position)
            if !allEmptyNeighborPositions.isEmpty {
                // check for bhar
                for neighbour in allEmptyNeighborPositions {
                    if checkBhar(for: neighbour, removingPos: position, player: player) {
                        positions.append((position, neighbour))
                    }
                }
            }
        }
        return positions
    }
    
    func posibleBharsArrayAfterOneMill(player: MillsPlayer, opponentPlayer: MillsPlayer) -> [Int] {
        var possibleCharpositionsToMakemill = [Int]()
        for possibleBhr in allPossibleBhrs {
            let first = player.playerPositions.contains(possibleBhr[0])
            let second = player.playerPositions.contains(possibleBhr[1])
            let third = player.playerPositions.contains(possibleBhr[2])
            if !first, second, third {
                if opponentPlayer.playerPositions.contains(possibleBhr[0]) {
                    possibleCharpositionsToMakemill.append(possibleBhr[0])
                }
            } else if first, !second, third {
                if opponentPlayer.playerPositions.contains(possibleBhr[1]) {
                    possibleCharpositionsToMakemill.append(possibleBhr[1])
                }
            } else if first, second, !third {
                if opponentPlayer.playerPositions.contains(possibleBhr[2]) {
                    possibleCharpositionsToMakemill.append(possibleBhr[2])
                }
            }
        }
        return possibleCharpositionsToMakemill
    }
    
    func posibleBharsArray(player: MillsPlayer, opponentPlayer: MillsPlayer) -> [[Int]] {
        var posibleBhars = Set<[Int]>()
        for possibleBhr in allPossibleBhrs {
            let first = player.playerPositions.contains(possibleBhr[0])
            let second = player.playerPositions.contains(possibleBhr[1])
            let third = player.playerPositions.contains(possibleBhr[2])
            if !first, second, third {
                if !opponentPlayer.playerPositions.contains(possibleBhr[0]) {
                    if player.playerRemainingPositions == 0 {
                        for pos in player.playerPositions {
                            if board.isNeighbor(from: possibleBhr[0], to: pos) {
                                posibleBhars.insert([possibleBhr[1], possibleBhr[2]])
                            }
                        }
                    } else {
                        posibleBhars.insert([possibleBhr[1], possibleBhr[2]])
                    }
                }
                
            } else if first, !second, third {
                if !opponentPlayer.playerPositions.contains(possibleBhr[1]) {
                    if player.playerRemainingPositions == 0 {
                        for pos in player.playerPositions {
                            if board.isNeighbor(from: possibleBhr[1], to: pos) {
                                posibleBhars.insert([possibleBhr[0], possibleBhr[2]])
                            }
                        }
                    } else {
                        posibleBhars.insert([possibleBhr[0], possibleBhr[2]])
                    }
                }
                
            } else if first, second, !third {
                if !opponentPlayer.playerPositions.contains(possibleBhr[2]) {
                    if player.playerRemainingPositions == 0 {
                        for pos in player.playerPositions {
                            if board.isNeighbor(from: possibleBhr[2], to: pos) {
                                posibleBhars.insert([possibleBhr[0], possibleBhr[1]])
                            }
                        }
                    } else {
                        posibleBhars.insert([possibleBhr[0], possibleBhr[1]])
                    }
                }
            }
        }
        return Array(posibleBhars)
    }
    
    override func getPositionToMove(board: MillsBoard) -> (from: Int, to: Int) {
        // make bhar
        var positions = posibleBhars(player: self)
        if !positions.isEmpty {
            return positions.random!
        }
        
        // stop bhar
        let opponentPlayerBharPositions = posibleBhars(player: board.opponentPlayer)
        if !opponentPlayerBharPositions.isEmpty {
            for position in playerPositions {
                let allEmptyNeighborPositions = board.allEmptyNeighborPositions(at: position)
                for pos in opponentPlayerBharPositions {
                    if allEmptyNeighborPositions.contains(pos.to) {
                        positions.append((position, pos.to))
                    }
                }
            }
        }
        if !positions.isEmpty {
            return positions.random!
        }
        
        // open already made bhar
        for bhar in allPossibleBhrs {
            let superSet = Set(playerPositions)
            let subSet = Set(bhar)
            if superSet.isSuperset(of: subSet) {
                for pos in bhar {
                    let allEmptyNeighborPositions = board.allEmptyNeighborPositions(at: pos)
                    if !allEmptyNeighborPositions.isEmpty {
                        positions.append((from: pos, to: allEmptyNeighborPositions.first!))
                    }
                }
            }
        }
        if !positions.isEmpty {
            return positions.random!
        }
        
        // try for future bhar
        let possiblePlacePositionsToMakeBhar = possiblePlacePositionsToMakeBhar(turn: board.current)
        if !possiblePlacePositionsToMakeBhar.isEmpty {
            for position in playerPositions {
                let allEmptyNeighborPositions = board.allEmptyNeighborPositions(at: position)
                for pos in possiblePlacePositionsToMakeBhar {
                    let emptyNeighbor = board.allEmptyNeighborPositions(at: pos)
                    let output = emptyNeighbor.filter(allEmptyNeighborPositions.contains)
                    for toPos in output {
                        positions.append((from: position, to: toPos))
                    }
                }
            }
        }
       
        if !positions.isEmpty {
            return positions.random!
        }
        
        // random
        print("random move")
        return RandomMillsPlayer(playerNumber: playerNumber, coinIcon: "", isPlaying: true, board: board).getPositionToMove(board: board)
    }
    
    override func charPosition() -> Int {
        var possibleCharPositions = [Int]()
        
        for position in board.currentPlayer.playerPositions {
            if !board.currentPlayer.isPositionInBhar(position: position) {
                possibleCharPositions.append(position)
            }
        }
        
        // stop bahr
        let opponentPosibleBharsArray = posibleBharsArray(player: board.currentPlayer, opponentPlayer: board.opponentPlayer)
        if let pos = opponentPosibleBharsArray.reduce([], +).duplicates().random {
            return pos
        } else if let pos = opponentPosibleBharsArray.reduce([], +).random {
            return pos
        }
        
        //make bhar
        let posibleBharsArrayAfterOneMill = posibleBharsArrayAfterOneMill(player: board.opponentPlayer, opponentPlayer: board.currentPlayer)
        if !posibleBharsArrayAfterOneMill.isEmpty {
            return posibleBharsArrayAfterOneMill.random!
        }
        
      return possibleCharPositions.random!
    }
    
    func checkBhar(for position: Int, removingPos: Int, player: MillsPlayer) -> Bool {
        let positionAfterChange = player.playerPositions.filter { $0 != removingPos} + [position]
        let listSet = Set(positionAfterChange)
        for bhar in allPossibleBhrs {
            let findListSet = Set(bhar)
            if findListSet.isSubset(of: listSet), !currentBhars.contains(bhar) {
                return true
            }
        }
        return false
    }
}
