//
//  PlayerGuideMessages.swift
//  Mills
//
//  Created by vishnu.d on 16/04/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import Foundation

enum MessageState {
  case place
  case selectForMove
  case moveSelected
  case bhar
}

class PlayerGuideMessages {
	class func getMessage(for state: MessageState) -> String {
		switch state {
		case .place:
			return "Place your coin at empty position."
		case .selectForMove:
			return "Select one of your movable coin to move."
		case .bhar:
			return "You have formed a mill! remove one of your opponent's coin."
		case .moveSelected:
			return "Select empty position to move this coin."
		}
	}
}
