//
//  ViewDataModel.swift
//  Mills
//
//  Created by vishnu.d on 27/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import Foundation
import UIKit

extension ViewDataModel {
  
  var rect1: CGRect {
    CGRect(x: (offset), y: offset, width: w-(offset*2), height: h-(offset*2))
  }
  var rect2: CGRect {
    CGRect(x: rect3start,y: rect3start, width: rect3Width,height: rect3Width)
  }
  
  var rect3: CGRect {
    CGRect(x: rect2start,y: rect2start,width: rect2Width,height: rect2Width)
  }
  
  var line1From: CGPoint {
    CGPoint(x: rect2start+(rect2Width/2), y: rect2start)
  }
  
  var line1To: CGPoint {
    CGPoint(x: mid, y: offset)
  }
  
  var line2From: CGPoint {
    CGPoint(x: rect2start, y: rect2start+(rect2Width/2))
  }
  
  var line2To: CGPoint {
    CGPoint(x: offset, y: mid)
  }
  
  var line3From: CGPoint {
    CGPoint(x: w-offset, y: mid)
  }
  
  var line3To: CGPoint {
    CGPoint(x: rect2start+rect2Width, y: mid)
  }
  
  var line4From: CGPoint {
    CGPoint(x: mid, y: h-offset)
  }
  
  var line4To: CGPoint {
    CGPoint(x: mid, y: rect2start+rect2Width)
  }
  
  func createCoinPositions(buttonSelected: @escaping (CoinPosition)->Void) -> [CoinPosition] {
    var coins = [CoinPosition]()
    func createButton(position: Int, origin: CGPoint) -> CoinPosition {
			return CoinPosition(position: position, origin: origin, buttonSize: CGSize(width: defaultButtonSize, height: defaultButtonSize), selectAction: buttonSelected)
    }
		let position1 = createButton(position: 1, origin: rect1.origin)
	     coins.append(position1)
    
		let position2 = createButton(position: 2, origin: CGPoint(x: rect1.midX, y: position1.origin.y))
    coins.append(position2)
    
		let position3 = createButton(position: 3, origin: CGPoint(x: rect1.maxX, y: position1.origin.y))
    coins.append(position3)
    
		let position4 = createButton(position: 4, origin: rect2.origin)
    coins.append(position4)
    
		let position5 = createButton(position: 5, origin: CGPoint(x: rect2.midX, y: position4.frame.minY))
    coins.append(position5)
    
    let position6 = createButton(position: 6, origin: CGPoint(x: rect2.maxX, y: position4.frame.minY))
    coins.append(position6)
    
		let position7 = createButton(position: 7, origin: rect3.origin)
    coins.append(position7)
    
		let position8 = createButton(position: 8, origin: CGPoint(x: rect3.midX, y: position7.frame.minY))
    coins.append(position8)
    
    let position9 = createButton(position: 9, origin: CGPoint(x: rect3.maxX, y: position7.frame.minY))
    coins.append(position9)
    
		let position10 = createButton(position: 10, origin: CGPoint(x: position1.origin.x, y: rect1.midY))
    coins.append(position10)
    
    let position11 = createButton(position: 11, origin: CGPoint(x: position4.origin.x, y: rect1.midY))
    coins.append(position11)
    
    let position12 = createButton(position: 12, origin: CGPoint(x: position7.origin.x, y: rect1.midY))
    coins.append(position12)
    
    let position13 = createButton(position: 13, origin: CGPoint(x: position9.origin.x, y: rect1.midY))
    coins.append(position13)
    
    let position14 = createButton(position: 14, origin: CGPoint(x: position6.origin.x, y: rect1.midY))
    coins.append(position14)
    
    let position15 = createButton(position: 15, origin: CGPoint(x: position3.origin.x, y: rect1.midY))
    coins.append(position15)
    
    let position16 = createButton(position: 16, origin: CGPoint(x: position7.origin.x, y: rect3.maxY))
    coins.append(position16)
    
    let position17 = createButton(position: 17, origin: CGPoint(x: position8.origin.x, y: rect3.maxY))
    coins.append(position17)
    
    let position18 = createButton(position: 18, origin: CGPoint(x: position9.origin.x, y: rect3.maxY))
    coins.append(position18)
    
		let position19 = createButton(position: 19, origin: CGPoint(x: rect2.minX, y: rect2.maxY))
    coins.append(position19)
    
		let position20 = createButton(position: 20, origin: CGPoint(x: rect2.midX, y: rect2.maxY))
    coins.append(position20)
    
		let position21 = createButton(position: 21, origin: CGPoint(x: rect2.maxX, y: rect2.maxY))
    coins.append(position21)
    
		let position22 = createButton(position: 22, origin: CGPoint(x: position1.origin.x, y: rect1.maxY))
    coins.append(position22)
    
    let position23 = createButton(position: 23, origin: CGPoint(x: position2.origin.x, y: rect1.maxY))
    coins.append(position23)
    
    let position24 = createButton(position: 24, origin: CGPoint(x: position3.origin.x, y: rect1.maxY))
    coins.append(position24)
    
    return coins
  }

}

extension ViewDataModel: CoinProvider {
  func provideCoinPositions(with buttonSelected: @escaping (CoinPosition) -> Void) -> [CoinPosition] {
    createCoinPositions(buttonSelected: buttonSelected)
  }
}


class ViewDataModel {
    var width: CGFloat
    var h: CGFloat { width }
    var w: CGFloat { width }
    var mid: CGFloat { width/2 }
	var rect2start: CGFloat { mid*0.70 }
	var rect2Width: CGFloat { w-(rect2start*2) }
	var rect3start: CGFloat { mid*0.40 }
	var rect3Width: CGFloat { w-(rect3start*2) }
	weak var view: UIView!
	var offset: CGFloat {
		22*ratio
	}

	var defaultButtonSize: CGFloat {
		45*ratio
	}

	let ratio: CGFloat
	
    init(ratio: CGFloat, width: CGFloat) {
		self.ratio = ratio
        self.width = width
	}
}
