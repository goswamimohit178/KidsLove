//
//  GameModels.swift
//  Mills
//
//  Created by vishnu.d on 27/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//


fileprivate let player1Color = UIColor.red
fileprivate let player2Color = UIColor.orange

import Foundation
import UIKit


class CoinPosition {
  let position: Int
  let origin: CGPoint
  let size: CGSize
  let selectAction: (CoinPosition) -> Void
  
  var frame: CGRect {
    return CGRect(origin: origin, size: size)
  }
	
	var circleFrame: CGRect {
		return CGRect(x: origin.x-size.width/2, y: origin.y-size.width/2, width: size.width, height: size.width)
	}
	
	
	var buttonFrame: CGRect {
		return CGRect(x: origin.x-size.width/2, y: origin.y-size.width/2, width: size.width, height: size.width)
	}
	
  
	init(position: Int, origin: CGPoint, buttonSize: CGSize, selectAction: @escaping (CoinPosition) -> Void) {
    self.position = position
    self.origin = origin
    self.size = buttonSize
    self.selectAction = selectAction
  }
  
  @objc func selector() {
    selectAction(self)
  }
  
  func changing(position: Int) ->  CoinPosition {
		CoinPosition(position: position, origin: origin, buttonSize: size, selectAction: selectAction)
  }
  
}


enum OccupiedBy {
  case player1
  case player2
  case none
  
  var borderCloor: UIColor {
    switch self {
    case .player1:
      return player1Color
    case .player2:
      return player2Color
    case .none:
      return .black
    }
  }
}
private let DEFAULT_COIN_COUNT = 9

class Player: NSObject {
  @objc dynamic var isPlaying: Bool
  @objc dynamic var playerPositions =  [Int]()
  @objc dynamic var playerRemainingPositions = DEFAULT_COIN_COUNT
  @objc dynamic var playerChars =  0
	@objc dynamic var messageForUser: String
  @objc dynamic private var currentBhars = [[Int]]()
  @objc dynamic var animateMessage: Bool = true
  var coinIcon: String
  
  init(isPlaying: Bool, coinIcon: String) {
    self.coinIcon = coinIcon
    self.isPlaying = isPlaying
		messageForUser = PlayerGuideMessages.getMessage(for: .place)
  }
  
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
    playerPositions.append(position)
  }
  
  func char(at position: Int) {
    playerChars = playerChars + 1
    playerPositions = playerPositions.filter { $0 != position }
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
    playerPositions = playerPositions.filter { $0 != from }
    playerPositions.append(to)
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

}
