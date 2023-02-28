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

struct Bhar {
  var positions: [Int]
  var possibleCharPositions: [Int]
}

class MillsGameViewModel {
   
    @State var currentPlayerCoinModel = CoinModel(imageName: "coin1", offset: 0)
    
  var coinPositions: [CoinPosition]!
	var player1Playing = true {
		didSet {
			if player1Playing {
				player1.isPlaying = true
				player2.isPlaying = false
			} else {
				player1.isPlaying = false
				player2.isPlaying = true
			}
			setMessage()
            playerChangeSubject.send(currentPlayer.coinIcon)
		}
  }
	
	func setMessage() {
		currentPlayer.setPlaceOrMoveMessage()
		opponentPlayer.messageForUser = ""
	}
	
	private var currentPlayer: Player {
		return player1.isPlaying ? player1: player2
	}
	
	private var opponentPlayer: Player {
		return player1.isPlaying ? player2: player1
	}
	
  let player1: Player
  let player2: Player
  private var lastSelectedposition: Int?
  private var lastBhar: Bhar?
  var playerChangeSubject: PassthroughSubject<String, Never>


  private var currentIntent: Intent = .place
  weak var delegate: GameViewDelegate?
    private let coinPositionsProvider: CoinProvider

  init(coinPositionsProvider: CoinProvider) {
    self.player1 = Player(isPlaying: true, coinIcon: "coin1")
    self.player2 = Player(isPlaying: false, coinIcon: "coin2")
    self.playerChangeSubject = PassthroughSubject()
    self.coinPositionsProvider = coinPositionsProvider
    setCoinPositions()
  }
    
    func setCoinPositions() {
        self.coinPositions = coinPositionsProvider.provideCoinPositions(with: self.select(coin:))
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
		guard checkIfAlreadyOccupied(position: coin.position) else {
			updateState(newState:.notAllowed, for: coin)
			return
		}
		if let selectedPosition = selectNewCoinIfPossible(coinPosition: coin) {
			lastSelectedposition = selectedPosition
			currentIntent = .placeMove
			let allEmptyNeighborPositions = self.allEmptyNeighborPositions(at: selectedPosition)
			updateState(newState:.selected(allEmptyNeighborPositions: allEmptyNeighborPositions), for: coin)
			return
		}
		print("Selected wrong cell")
		updateState(newState:.notAllowed, for: coin)
	}
  
	func select(coin: CoinPosition) {
		print(currentIntent)
		switch currentIntent {
		case .place:
			guard checkIfAllowedToPlaceAtNewposition(coin) else {
				updateState(newState: .notAllowed, for: coin)
				return
			}
			placeAtNewPosition(coin)
		case .selectForMove:
			selectForMove(coin: coin)
			return
		case .placeMove:
			if let lastSelectedposition = lastSelectedposition {
				guard canMove(from: lastSelectedposition, to: coin.position) else {
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
  
	func isPlayerCantMove(player: Player) -> Bool {
		guard player.isPlacedAllCoins, !player.isOnly3Left()  else {
      return false
    }
    let allPossibleMoves = player.playerPositions.filter(canCoinMoveFrom)
    return allPossibleMoves.count == 0
  }
  
  func checkIfAlreadyOccupied(position: Int) -> Bool {
    return player1.playerPositions.contains(position) || player2.playerPositions.contains(position)
  }
  
	fileprivate func placeAtNewPosition(_ coinPosition: CoinPosition) {
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
  
  fileprivate func canMove(from: Int, to position: Int) -> Bool {
    guard !checkIfAlreadyOccupied(position: position) else {
      return false
    }
    if currentPlayer.playerPositions.count == 3 {
			return true
		}
    return isNeighbor(from: from, to: position)
   }
  
  private func isNeighbor(from: Int, to: Int) -> Bool {
    return neighborMap[from]!.contains(to)
  }
	
	private func areNeighborsEmpty(at: Int) -> Bool {
		let allEmptyNeighborPositions = self.allEmptyNeighborPositions(at: at)
		return !allEmptyNeighborPositions.isEmpty
  }
	
	private func allEmptyNeighborPositions(at: Int) -> [Int] {
		guard !currentPlayer.isOnly3Left() else {
			return allEmptyPositions()
		}
		return neighborMap[at]!.filter { position in
			!currentPlayer.playerPositions.contains(position) && !opponentPlayer.playerPositions.contains(position)
		}
	}
	
	private func allEmptyPositions() -> [Int] {
		let allOccupied = player1.playerPositions + player1.playerPositions
		return (1...24).filter { !allOccupied.contains($0) }
	}
  
  fileprivate func move(_ lastSelectedposition: Int, _ coinPosition: CoinPosition) {
		currentPlayer.movePosition(from: lastSelectedposition, to: coinPosition.position)
  }
  
  private func selectNewCoinIfPossible(coinPosition: CoinPosition) -> Int? {
    if currentPlayer.playerRemainingPositions == 0 && currentPlayer.playerPositions.contains(coinPosition.position),
			areNeighborsEmpty(at: coinPosition.position) {
      return coinPosition.position
    }
    return nil
  }
  
  fileprivate func checkIfAllowedToPlaceAtNewposition(_ coinPosition: CoinPosition) -> Bool {
    guard !checkIfAlreadyOccupied(position: coinPosition.position) else {
      return false
    }
		if currentPlayer.playerRemainingPositions == 0 {
			return false
		}
		currentPlayer.playerPositions.append(coinPosition.position)
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
