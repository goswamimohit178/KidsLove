//
//  MillsMillsGameViewModel.swift
//  Mills
//
//  Created by vishnu.d on 27/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftUI
import Combine

struct Bhar {
  var positions: [Int]
  var possibleCharPositions: [Int]
}

class MillsGameViewModel {
    @State var currentPlayerCoinModel = CoinModel(imageName: "coin1", offset: 0)
    
    let millsBoard: MillsBoard
    var coinPositions: [CoinPosition]!
    var matchManager: MatchManager?

    var player1Playing = true {
        didSet {
            if player1Playing {
                player1.isPlaying = true
                player2.isPlaying = false
            } else {
                player1.isPlaying = false
                player2.isPlaying = true
            }
            millsBoard.current = player1Playing ? 0 : 1
            setMessage()
            playerChangeSubject.send(currentPlayer.coinIcon)
        }
    }
    
    func playWithComputerPlayer() {
        guard isWon() == nil else {
            return
        }
        guard ((currentPlayer is SmartMillsPlayer) ||
        (currentPlayer is RandomMillsPlayer) ||
        (currentPlayer is SmarterMillsPlayer)) else {
            return
        }
        switch currentIntent {
        case .place:
            computerPlayerPlace()
        case .selectForMove:
            computerPlayerMove()
        case .placeMove:
            fatalError("Invalid state")
        case .char:
            computerPlayerChar()
        }
    }
    
    func computerPlayerPlace() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let position = self.currentPlayer.getPositionToPlace(board: self.millsBoard)
            self.select(position: position)
        }
    }
    
    func computerPlayerMove() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let position = self.currentPlayer.getPositionToMove(board: self.millsBoard)
            self.select(position: position.from)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.select(position: position.to)
            }
        }
    }
    
    func computerPlayerChar() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let position = self.currentPlayer.charPosition()
            self.select(position: position)
        }
    }
	
	func setMessage() {
		currentPlayer.setPlaceOrMoveMessage()
		opponentPlayer.messageForUser = ""
	}
	
	private var currentPlayer: MillsPlayer {
		return player1.isPlaying ? player1: player2
	}
	
	private var opponentPlayer: MillsPlayer {
		return player1.isPlaying ? player2: player1
	}
	
  let player1: MillsPlayer
  let player2: MillsPlayer
  private var lastSelectedposition: Int?
  private var lastBhar: Bhar?
  var playerChangeSubject: PassthroughSubject<String, Never>


    private var currentIntent: Intent = .place {
        didSet {
            if case .char = currentIntent {
                playWithComputerPlayer()
            }
        }
    }
  weak var delegate: GameViewDelegate?
  private let coinPositionsProvider: CoinProvider

    init(coinPositionsProvider: CoinProvider, gameMode: PlayWith, matchManager: MatchManager? = nil) {
        self.matchManager = matchManager
        self.millsBoard = MillsBoard()
        self.player1 = MillsPlayer(playerNumber: 0, coinIcon: "coin1", isPlaying: true, board: millsBoard)
        switch gameMode {
        case .withPlayerOffline:
            self.player2 = MillsPlayer(playerNumber: 1, coinIcon: "coin1", isPlaying: true, board: millsBoard)
        case .withComputer(level: let level):
            switch level {
            case .easyLevel:
                self.player2 =  RandomMillsPlayer(playerNumber: 1, coinIcon: "coin2", isPlaying: false, board: millsBoard)
                
            case .mediumLevel:
                self.player2 =  SmartMillsPlayer(playerNumber: 1, coinIcon: "coin2", isPlaying: false, board: millsBoard)
                
            case .HardLevel:
                self.player2 =  SmarterMillsPlayer(playerNumber: 1, coinIcon: "coin2", isPlaying: false, board: millsBoard)
            }
            
        }
        millsBoard.players = [player1, player2]
        self.playerChangeSubject = PassthroughSubject()
        self.coinPositionsProvider = coinPositionsProvider
        setCoinPositions()
        playWithComputerPlayer()
    }
    
    func setCoinPositions() {
        self.coinPositions = coinPositionsProvider.provideCoinPositions(with: self.select(position:))
    }
  
	func checkBhar() -> Bhar? {
		if let bharPositions = currentPlayer.checkBhar() {
			return Bhar(positions: bharPositions, possibleCharPositions: opponentPlayer.canCharAtPositions())
		}
		return nil
	}
}

extension MillsGameViewModel {
  
  private func charIfPossible(coinPosition: CoinPosition, bhar: Bhar) -> Int? {
    if opponentPlayer.playerPositions.contains(coinPosition.position), !opponentPlayer.isPositionInBhar(position: coinPosition.position) {
      opponentPlayer.char(at: coinPosition.position)
      return coinPosition.position
    }
    return nil
  }
  
  fileprivate func changePlayer() {
    player1Playing = !player1Playing
    playWithComputerPlayer()
  }
  
  fileprivate func charIfPossible(_ coinPosition: CoinPosition) {
    if let lastBhar = lastBhar {
      if let position = charIfPossible(coinPosition: coinPosition, bhar: lastBhar) {
        self.lastBhar = nil
        currentIntent = canOpponentPlace() ? Intent.place: Intent.selectForMove
        updateState(newState:.char(atposition: position, player1: player1Playing, isWon: isWon()), for: coinPosition)
        changePlayer()
        return
      }
      updateState(newState:.notAllowed, for: coinPosition)
      return
    }
    fatalError("Must have last bhar for char")
  }
	
	private func selectForMove(coin: CoinPosition) {
        guard millsBoard.checkIfAlreadyOccupied(position: coin.position) else {
			updateState(newState:.notAllowed, for: coin)
			return
		}
		if let selectedPosition = selectNewCoinIfPossible(coinPosition: coin) {
			lastSelectedposition = selectedPosition
			currentIntent = .placeMove
            let allEmptyNeighborPositions = millsBoard.allEmptyNeighborPositions(at: selectedPosition)
			updateState(newState:.selected(allEmptyNeighborPositions: allEmptyNeighborPositions), for: coin)
			return
		}
		print("Selected wrong cell")
		updateState(newState:.notAllowed, for: coin)
	}
    
    func select(position: Int) {
        select(position: position, sendToRemote: true)
    }
  
    func select(position: Int, sendToRemote: Bool) {
        if sendToRemote, let matchManager = matchManager {
            guard let encoded = "\(position)".data(using: .utf8 ) else{ return }
            matchManager.sendData(Data(encoded))
        }
        let coin = coinPositions[position-1]
		print("CurrentIntent:", currentIntent, "Position:", position)
		switch currentIntent {
		case .place:
			guard checkAndPlaceAtPosition(coin) else {
				updateState(newState: .notAllowed, for: coin)
				return
			}
            placedAtNewPosition(coin)
		case .selectForMove:
			selectForMove(coin: coin)
			return
		case .placeMove:
			if let lastSelectedposition = lastSelectedposition {
                guard millsBoard.canMove(from: lastSelectedposition, to: coin.position) else {
					//to selectMove here
					selectForMove(coin: coin)
					return
				}
				move(lastSelectedposition, coin)
				//possible bhar
				if let lastBhar = checkBhar() {
					self.lastBhar = lastBhar
					self.lastSelectedposition = nil
					currentIntent = .char
					updateState(newState:.move(player1: player1Playing, from: lastSelectedposition, to: coin.position, bhar: lastBhar, isWon: isWon()), for: coin)
				} else {
					self.lastSelectedposition = nil
					currentIntent = canOpponentPlace() ? Intent.place: Intent.selectForMove
					updateState(newState:.move(player1: player1Playing, from: lastSelectedposition, to: coin.position, bhar: nil, isWon: isWon()), for: coin)
					changePlayer()
				}
				return
			}
		case .char:
			charIfPossible(coin)
		}
	}
  
  func isWon() -> Won? {
    if player1.isLost {
      return Won(isPlayer1Won: false)
    }
    
    if player2.isLost {
      return Won(isPlayer1Won: true)
    }
    
    if isPlayerCantMove(player: player1) {
      return Won(isPlayer1Won: false)
    }
    
    if isPlayerCantMove(player: player2) {
      return Won(isPlayer1Won: true)
    }
    return nil
  }
  
  func canCoinMoveFrom(position: Int) -> Bool {
    return neighborMap[position]!.first { neighbor in
      (!player1.playerPositions.contains(neighbor) &&  !player2.playerPositions.contains(neighbor))
    } != nil
  }
  
	func isPlayerCantMove(player: MillsPlayer) -> Bool {
		guard player.isPlacedAllCoins, !player.isOnly3Left()  else {
      return false
    }
    let allPossibleMoves = player.playerPositions.filter(canCoinMoveFrom)
    return allPossibleMoves.count == 0
  }
  
	fileprivate func placedAtNewPosition(_ coinPosition: CoinPosition) {
		//possible bhar
		if let lastBhar = checkBhar() {
			self.lastBhar = lastBhar
			print("Placing at new position: \(coinPosition.position)")
			currentIntent = .char
			updateState(newState:.placed(player1: player1Playing, bhar: lastBhar, isWon: isWon()), for: coinPosition)
		} else {
			print("Placing at new position: \(coinPosition.position)")
			currentIntent = canOpponentPlace() ? Intent.place: Intent.selectForMove
			updateState(newState:.placed(player1: player1Playing, bhar: lastBhar, isWon: isWon()), for: coinPosition)
			changePlayer()
		}
	}
  
  private func canOpponentPlace() -> Bool {
    return opponentPlayer.playerRemainingPositions != 0
  }
  
  fileprivate func move(_ lastSelectedposition: Int, _ coinPosition: CoinPosition) {
		currentPlayer.movePosition(from: lastSelectedposition, to: coinPosition.position)
  }
  
  private func selectNewCoinIfPossible(coinPosition: CoinPosition) -> Int? {
    if currentPlayer.playerRemainingPositions == 0 && currentPlayer.playerPositions.contains(coinPosition.position),
       millsBoard.areNeighborsEmpty(at: coinPosition.position) {
      return coinPosition.position
    }
    return nil
  }
  
  fileprivate func checkAndPlaceAtPosition(_ coinPosition: CoinPosition) -> Bool {
      guard !millsBoard.checkIfAlreadyOccupied(position: coinPosition.position) else {
      return false
    }
		if currentPlayer.playerRemainingPositions == 0 {
			return false
		}
		currentPlayer.place(at: coinPosition.position)
		currentPlayer.playerRemainingPositions = currentPlayer.playerRemainingPositions - 1
    return true
  }
	
    func updateState(newState: PlayerAction, for coinPosition: CoinPosition) {
        switch currentIntent {
        case .place:
            currentPlayer.messageForUser = PlayerGuideMessages.getMessage(for: .place)
        case .selectForMove:
            currentPlayer.messageForUser = PlayerGuideMessages.getMessage(for: .selectForMove)
        case .placeMove:
            currentPlayer.messageForUser = PlayerGuideMessages.getMessage(for: .moveSelected)
        case .char:
            currentPlayer.messageForUser = PlayerGuideMessages.getMessage(for: .bhar)
        }
        if case PlayerAction.notAllowed = newState {
            currentPlayer.animateMessage = true
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "id-notAllowed",
                AnalyticsParameterItemName: "notAllowed pressed",
                AnalyticsParameterContentType: "cont"
            ])		}
        delegate?.stateChanged(newState: newState, for: coinPosition)
    }
}



protocol GameViewDelegate: AnyObject {
  func stateChanged(newState: PlayerAction, for coinPosition: CoinPosition)
}

enum PlayerAction {
	case selected(allEmptyNeighborPositions: [Int])
  case placed(player1: Bool, bhar: Bhar?, isWon: Won?)
  case notAllowed
  case move(player1: Bool, from: Int, to: Int, bhar: Bhar?, isWon: Won?)
  case char(atposition: Int, player1: Bool, isWon: Won?)
}

enum Intent {
  case place
  case selectForMove
  case placeMove
  case char
}

struct Won {
  let isPlayer1Won: Bool
}
