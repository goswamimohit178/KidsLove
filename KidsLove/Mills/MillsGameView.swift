//
//  GameView.swift
//  Mills
//
//  Created by vishnu.d on 27/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import UIKit
import AudioToolbox


class MillsGameView: UIView {
  private let ratio: CGFloat
  private var buttons = [UIButton]()
  private var circles = [CircleView]()
  private var circleAnimatingViews = [CircleView]()
  private var viewDataModel: ViewDataModel!
  var viewModel: MillsGameViewModel?
  var showAlert: ((String)-> Void)!
	
  var lineWidth: CGFloat {
		5.0*ratio
  }
	var buttonSize: CGFloat {
		45*ratio
	}
  
	var circleWidth: CGFloat {
		35*ratio
	}
    
    var defaultColor: UIColor {
        UIColor.defaultThemeColor
    }

  private let soundEffects = SoundEfectManager()
  private var selectionAnimatingView: UIView?
  private var bahrAnimatingViews = [UIView]()
  private var bahrAnimatingLayer: CALayer?

    init(viewDataModel: ViewDataModel,  viewModel: MillsGameViewModel, ratio: CGFloat) {
        self.ratio = ratio
        super.init(frame: .zero)
        self.viewModel = viewModel
        self.viewDataModel = viewDataModel
        setup()
    }
    
    func setup() {
        drawCircles(for: viewModel!.coinPositions, colour: defaultColor)
        buttons = Array(0...24).map {_ in return UIButton() }
        addButtons(for: viewModel!.coinPositions)
    }
  
	private func button(with coinPosition: CoinPosition) -> UIButton {
		let button = UIButton(frame: coinPosition.buttonFrame)
		let cornerRadius : CGFloat = button.frame.width/2
		let maxGlowSize : CGFloat = 12
		button.layer.shadowRadius = maxGlowSize
		button.layer.cornerRadius = cornerRadius
		button.layer.shadowPath = CGPath(roundedRect: button.bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
		button.layer.shadowRadius = 0
		button.layer.shadowOffset = CGSize.zero
		button.layer.shadowOpacity = 0.66
		button.layer.shadowColor = UIColor.clear.cgColor
		button.addTarget(coinPosition, action: #selector(coinPosition.selector), for: .touchUpInside)
		buttons[coinPosition.position] = button
		return button
	}
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func placeCoin(_ isPlayer1: Bool, _ newButon: UIButton) {
    let image = isPlayer1 ? "coin1" : "coin2"
    newButon.setImage(UIImage(named: image), for: .normal)
  }
  
	func animateSelection(button: UIButton) {
		selectionAnimatingView = button
		UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
			button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
		}, completion: nil)
	}
	
	func animate(allEmptyNeighborPositions: [Int]) {
		circleAnimatingViews = allEmptyNeighborPositions
			.map { circles[$0-1] }
		circleAnimatingViews.forEach { $0.animateCircle(duration: 0.5)}
	}
	
	func stopCircleAnimation() {
		circleAnimatingViews.forEach { view in
			view.circleLayer.removeAllAnimations()
			view.circleLayer.strokeEnd = 0.0
		}
		self.circleAnimatingViews = []
	}
    
  func stopSelectionAnimation() {
    guard let selectionAnimatingView = selectionAnimatingView else {
      return
    }
    selectionAnimatingView.transform = CGAffineTransform(scaleX: 1, y: 1)
    selectionAnimatingView.layer.removeAllAnimations()
    self.selectionAnimatingView = nil
  }
  
	func stopBharAnimation() {
		bahrAnimatingViews.forEach { view in
			view.layer.shadowColor = UIColor.clear.cgColor
			view.layer.removeAllAnimations()
		}
		self.bahrAnimatingViews = []
		guard let bahrAnimatingLayer = bahrAnimatingLayer else {
			return
		}
		bahrAnimatingLayer.removeFromSuperlayer()
		self.bahrAnimatingLayer = nil
	}
  
  
  
	func animateView(view: UIView, glowColor : UIColor) {
		let animDuration : CGFloat = 3
		let maxGlowSize : CGFloat = 12
		let minGlowSize : CGFloat = 3
		view.layer.shadowColor = glowColor.cgColor
		
		let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
		layerAnimation.fromValue = maxGlowSize
		layerAnimation.toValue = minGlowSize
		layerAnimation.autoreverses = true
		layerAnimation.isAdditive = false
		layerAnimation.duration = CFTimeInterval(animDuration/2)
		layerAnimation.fillMode = CAMediaTimingFillMode.forwards
		layerAnimation.isRemovedOnCompletion = false
		layerAnimation.repeatCount = .infinity
		view.layer.add(layerAnimation, forKey: "glowingAnimation")
		bahrAnimatingViews.append(view)
	}
  
	fileprivate func animateBhar(_ bhar: Bhar) {
		let buttonsToAnimate = bhar.positions.map { buttons[$0]}
		var rect: CGRect!
		if buttonsToAnimate[0].frame.minX == buttonsToAnimate[2].frame.minX {
			// draw vertical line
			rect = CGRect(x: buttonsToAnimate[0].frame.minX, y: buttonsToAnimate[0].frame.minY, width: buttonSize, height: (buttonsToAnimate[2].frame.maxY-buttonsToAnimate[0].frame.minY))
		} else {
			// draw horizontal line
			rect = CGRect(x: buttonsToAnimate[0].frame.minX, y: buttonsToAnimate[0].frame.minY, width: (buttonsToAnimate[2].frame.maxX-buttonsToAnimate[0].frame.minX), height: buttonSize)
		}
		let layer = CAShapeLayer()
		layer.path = UIBezierPath(roundedRect: rect, cornerRadius: 50).cgPath
		layer.lineWidth = 1
		layer.fillColor = nil
		layer.opacity = 1.0
		layer.strokeColor = UIColor.green.cgColor
		layer.masksToBounds = false
		layer.shadowColor = UIColor.green.cgColor
		layer.shadowRadius = 0
		layer.shadowOpacity = 0.66
		layer.shadowOffset = .zero
		bahrAnimatingLayer = layer
		self.layer.addSublayer(layer)
		
		let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
		glowAnimation.fromValue = 0
		glowAnimation.toValue = 15
		glowAnimation.beginTime = CACurrentMediaTime()+0.3
		glowAnimation.duration = CFTimeInterval(5.3)
		glowAnimation.fillMode = .removed
		glowAnimation.autoreverses = true
		glowAnimation.isRemovedOnCompletion = true
		layer.add(glowAnimation, forKey: "shadowGlowingAnimation")
		
		bhar.possibleCharPositions
			.map { buttons[$0] }
			.forEach { button in
				animateView(view: button, glowColor: UIColor.systemRed)
		}
		
		buttonsToAnimate.forEach { button in
			animateView(view: button, glowColor: UIColor.systemGreen)
		}
	}
  
  func userWon(won: Won) {
    soundEffects.playSoundAlertFor(type: won.isPlayer1Won ? SoundAlertType.won: SoundAlertType.lost)
    showAlert(won.isPlayer1Won ? "You won :)":  "You lost ):")
  }
  
  func addButtons(for coinPositions: [CoinPosition]) {
    coinPositions.map { button(with: $0) }.forEach(addSubview)
  }
  
}

extension MillsGameView: GameViewDelegate {
	func stateChanged(newState: PlayerAction, for coinPosition: CoinPosition) {
        print(newState)
        switch newState {
        case .selected(let allEmptyNeighborPositions):
            stopSelectionAnimation()
						stopCircleAnimation()
            animateSelection(button: buttons[coinPosition.position])
						animate(allEmptyNeighborPositions: allEmptyNeighborPositions)
            soundEffects.playSoundAlertFor(type: .select)
        case .placed(let isPlayer1, let bhar, let isWon):
            placeCoin(isPlayer1, buttons[coinPosition.position])
            if let isWon = isWon {
                userWon(won: isWon)
            } else if let bhar = bhar {
                animateBhar(bhar)
                soundEffects.playSoundAlertFor(type: .bhar)
            } else {
                soundEffects.playSoundAlertFor(type: .place)
            }
            
        case .notAllowed:
            print("Not allowed")
            soundEffects.playSoundAlertFor(type: .notAllowed)
        case .move(let isPlayer1, let from, let to, let bhar, let isWon):
					  stopCircleAnimation()
            stopSelectionAnimation()
            let oldButton = buttons[from]
            let newButon = buttons[to]
            placeCoin(isPlayer1, newButon)
            
            oldButton.setImage(nil, for: .normal)
            newButon.layer.position = oldButton.layer.position
            soundEffects.playSoundAlertFor(type: .move)
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                newButon.frame = coinPosition.buttonFrame
            }, completion: {_ in
                if let isWon = isWon {
                    self.userWon(won: isWon)
                    return
                }
                if let bhar = bhar {
                    self.animateBhar(bhar)
                    self.soundEffects.playSoundAlertFor(type: .bhar)
                }
            })
        case .char(let atposition, _ , let isWon):
            buttons[atposition].setImage(nil, for: .normal)
            if let isWon = isWon {
                userWon(won: isWon)
            } else {
                soundEffects.playSoundAlertFor(type: .char)
            }
            stopBharAnimation()
        }
    }
}


// drawing
extension MillsGameView {
  
  func drawRects() {
    let color:UIColor = defaultColor
    
    let drect1 = viewDataModel.rect1
    let drect3 = viewDataModel.rect3
    let drect2 = viewDataModel.rect2
    
    let bpath1:UIBezierPath = UIBezierPath(rect: drect1)
    bpath1.lineWidth = lineWidth
    color.set()
    bpath1.stroke()
    
    let bpath2:UIBezierPath = UIBezierPath(rect: drect2)
    bpath2.lineWidth = lineWidth
    bpath2.stroke()
    
    let bpath3:UIBezierPath = UIBezierPath(rect: drect3)
    bpath3.lineWidth = lineWidth
    bpath3.stroke()
    print("drawRect has updated the view")
  }
  
  func drawLines() {
    //line 1
    if let context = UIGraphicsGetCurrentContext() {
      context.setStrokeColor(defaultColor.cgColor)
      context.setLineWidth(lineWidth)
      context.move(to: viewDataModel.line1From)
      context.addLine(to: viewDataModel.line1To)
      context.strokePath()
    }
    //line 2
    
    if let context = UIGraphicsGetCurrentContext() {
      context.setStrokeColor(defaultColor.cgColor)
      context.setLineWidth(lineWidth)
      context.move(to: viewDataModel.line2From)
      context.addLine(to: viewDataModel.line2To)
      context.strokePath()
    }
    
    //line 3
    if let context = UIGraphicsGetCurrentContext() {
      context.setStrokeColor(defaultColor.cgColor)
      context.setLineWidth(lineWidth)
      context.move(to: viewDataModel.line3From)
      context.addLine(to: viewDataModel.line3To)
      context.strokePath()
    }
    
    //line 4
    if let context = UIGraphicsGetCurrentContext() {
      context.setStrokeColor(defaultColor.cgColor)
      context.setLineWidth(lineWidth)
      context.move(to: viewDataModel.line4From)
      context.addLine(to: viewDataModel.line4To)
      context.strokePath()
    }
    
  }
  
  func setBackground() {
//    let image = UIImageView(image: UIImage(named: "background"))
//    image.frame = self.bounds
//    self.addSubview(image)
  }
  
  override func draw(_ rect: CGRect) {
//    let image = UIImageView(image: UIImage(named: "background"))
//    image.frame = self.bounds
//    image.draw(rect)
    drawRects()
    drawLines()
  }
	
	func buttonOrigin(_ frame: CGRect) -> CGRect {
		return CGRect(x: frame.origin.x-circleWidth/2, y: frame.origin.y-circleWidth/2, width: circleWidth, height: circleWidth)
	}
  
	func drawCircles(for coinPositions: [CoinPosition], colour: UIColor) {
		self.circles = coinPositions.map { CircleView(frame: buttonOrigin($0.frame)) }
		circles.forEach(addSubview)
	}
}

enum SoundAlertType {
  case place
  case select
  case notAllowed
  case bhar
  case char
  case move
  case won
  case lost
}
