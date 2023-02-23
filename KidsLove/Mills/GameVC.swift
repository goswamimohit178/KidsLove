//
//  GameVC.swift
//  Mills
//
//  Created by vishnu.d on 26/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import UIKit
import Firebase

var ratio: CGFloat = 1
var isUserOnMute = false

class GameVC: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  private var gameView: MillsGameView!
  private var player1View: PlayerView!
  private var player2View: PlayerView!
	private var soundButton: UIButton!
	private var restartButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    blurredView.frame = view.bounds
    view.addSubview(blurredView)
    startNewGame()
  }
	
	func startNewGame() {
		createNewGame()
		setCurrentPlayer()
	}
	
	func setCurrentPlayer() {
		gameView!.viewModel!.player1Playing = true
	}
  
  fileprivate func cleanup() {
    gameView.removeFromSuperview()
    player1View.removeFromSuperview()
    player2View.removeFromSuperview()
		soundButton.removeFromSuperview()
		restartButton.removeFromSuperview()
  }
  
  func showAlert(message: String) {
		showAlert(title: "Game over!", message: "Do you want to start a new game?")
  }
  
  fileprivate func createNewGame() {
    let myFrame = view.bounds
    let isWidthLess = (myFrame.width < myFrame.height)
    let widthRequired = (isWidthLess ? myFrame.width: myFrame.height)
		ratio = widthRequired/350
		let estimatedPlayerHeight = ((myFrame.height-widthRequired-60)/2)
		let height: CGFloat = estimatedPlayerHeight > 100 ? 100: estimatedPlayerHeight
		let restartButtonHeight: CGFloat = 60
		var availableSpace = myFrame.height - (height + widthRequired + height + restartButtonHeight)
		availableSpace = availableSpace>0 ? availableSpace: 0
		player2View = PlayerView.instanceFromNib(ratio: ratio) as? PlayerView
		player2View.frame = CGRect(x: 5, y: myFrame.maxY-height-availableSpace*0.33, width: myFrame.width-10, height: height)
		
    let xRequired = isWidthLess ? 0: (((myFrame.width - widthRequired)/2))
		let yRequired = isWidthLess ? (myFrame.height - widthRequired-player2View.frame.height-availableSpace*0.50): 0

		player1View = PlayerView.instanceFromNib(ratio: ratio) as? PlayerView
		view.addSubview(player2View)
		
    let boardRect = CGRect(x: xRequired, y: yRequired, width: widthRequired, height: widthRequired)
		player1View.frame = CGRect(x: 5, y: boardRect.minY-height-availableSpace*0.20, width: myFrame.width-10, height: height)
		
		restartButton = UIButton()
		restartButton.setTitle("Restart", for: .normal)
		restartButton.addTarget(self, action: #selector(restartButtonAction), for: .touchUpInside)
		
		soundButton = UIButton()
		soundButton.setTitle("Mute", for: .normal)
		soundButton.addTarget(self, action: #selector(muteButtonAction), for: .touchUpInside)
		
//		restartButton.backgroundColor = .red
		if #available(iOS 13.0, *) {
			restartButton.setImage(UIImage(systemName: "play"), for: .normal)
			soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
		} else {
			// Fallback on earlier versions
		}
		let restartButtonWidth: CGFloat = 200
		let y = (availableSpace > 0) ? (availableSpace*0.20): 10
		restartButton.frame = CGRect(x: myFrame.width-restartButtonWidth-20, y: y, width: restartButtonWidth, height: restartButtonHeight)
		soundButton.frame = CGRect(x: 20, y: y, width: 100, height: restartButtonHeight)
		restartButton.tintColor = .white
		soundButton.tintColor = .white
		restartButton.contentVerticalAlignment = .center
		view.addSubview(restartButton)
		view.addSubview(soundButton)
		view.addSubview(player1View)
		
		let viewDataModel = ViewDataModel(frame: boardRect, ratio: ratio)
		
    let player1 = Player(isPlaying: true, coinIcon: "coin1")
    let player2 = Player(isPlaying: false, coinIcon: "coin2")
    let viewModel = MillsGameViewModel(CoinPositionsProvider: viewDataModel, player1: player1, player2: player2)
	  gameView = MillsGameView(frame: boardRect, viewDataModel: viewDataModel, viewModel: viewModel, ratio: ratio)
    gameView.viewModel = viewModel
    viewModel.delegate = gameView
    gameView.showAlert = showAlert
    player1View.currentPlayer = player1
    player2View.currentPlayer = player2
    player1View.opponent = player2
    player2View.opponent = player1
    view.addSubview(gameView)

    setShadow(view: player2View)
    setShadow(view: player1View)
    setShadow(view: gameView)
    
    setCornerRadius(view: player1View)
    setCornerRadius(view: player2View)
   }
	
	fileprivate func showAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
			self.cleanup()
			self.startNewGame()
		})
		alert.addAction(UIAlertAction(title: "No", style: .cancel))
		self.present(alert, animated: false, completion: nil)
	}
	
	@objc func restartButtonAction(button: UIButton) {
		showAlert(title: "Restart Game!", message: "Are you sure you want to restart?")
		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-\(button.titleLabel!.text!)",
			AnalyticsParameterItemName: "User restarted game",
			AnalyticsParameterContentType: "cont"
		])
	}
	
	@objc func muteButtonAction(button: UIButton) {
		isUserOnMute = !isUserOnMute
		if isUserOnMute {
			button.setTitle("Unmute", for: .normal)
		} else {
			button.setTitle("Mute", for: .normal)
		}
		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-\(button.titleLabel!.text!)",
			AnalyticsParameterItemName: "User muted",
			AnalyticsParameterContentType: "cont"
		])
	}
  
  func setShadow(view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 5, height: 5)
		view.layer.shadowOpacity = 0.66
    view.layer.shadowRadius = 20.0
  }
  
  func setCornerRadius(view: UIView) {
    view.layer.borderWidth = 2
    view.layer.borderColor = UIColor.white.cgColor
    view.layer.cornerRadius = 15
  }
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}


protocol CoinProvider {
  func provideCoinPositions(with buttonSelected: @escaping (CoinPosition)->Void ) -> [CoinPosition]
}

