//
//  GameVC.swift
//  Mills
//
//  Created by vishnu.d on 26/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import UIKit
import Firebase
import SwiftUI
import Combine

var ratio: CGFloat = 1
var isUserOnMute = false

class GameVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var gameView: MillsGameView!
    private var playerView: UIView!
    private var soundButton: UIButton!
    private var restartButton: UIButton!
    
    private var disposable = Set<AnyCancellable>()
    
    @Published var headerModel: HeaderViewModel!
    var headerView: HeaderView!

    
    var viewModel: MillsGameViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func startNewGame() {
        createNewGame()
        setCurrentPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func setCurrentPlayer() {
        gameView!.viewModel!.player1Playing = true
    }
    
    fileprivate func cleanup() {
        gameView.removeFromSuperview()
        playerView.removeFromSuperview()
        soundButton.removeFromSuperview()
        restartButton.removeFromSuperview()
    }
    
    func showAlert(message: String) {
        showAlert(title: "Game over!", message: "Do you want to start a new game?")
    }
    
    fileprivate func createNewGame() {
//        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        let margins = view.safeAreaLayoutGuide

        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true

        
        //buttons
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        
        restartButton = UIButton()
        restartButton.setTitle("Restart", for: .normal)
        restartButton.addTarget(self, action: #selector(restartButtonAction), for: .touchUpInside)
        restartButton.setTitleColor(UIColor.defaultTextColor(), for: .normal)
        restartButton.tintColor = UIColor.defaultThemeColor

        soundButton = UIButton()
        soundButton.setTitleColor(UIColor.defaultTextColor(), for: .normal)
        soundButton.setTitle("Mute", for: .normal)
        soundButton.addTarget(self, action: #selector(muteButtonAction), for: .touchUpInside)
        soundButton.tintColor = UIColor.defaultThemeColor
        
        restartButton.setImage(UIImage(systemName: "play"), for: .normal)
        soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        
        buttonStackView.addArrangedSubview(soundButton)
        buttonStackView.addArrangedSubview(restartButton)
        
        stackView.addArrangedSubview(buttonStackView)

        
        // Header view
        let myFrame = margins.layoutFrame
        let isWidthLess = (myFrame.width < myFrame.height)
        let widthRequired = min((isWidthLess ? myFrame.width: myFrame.height), 70000)
        ratio = widthRequired/350
        let estimatedPlayerHeight = ((myFrame.height-widthRequired-60)/2)
        let height: CGFloat = estimatedPlayerHeight > 100 ? 100: estimatedPlayerHeight
        let restartButtonHeight: CGFloat = 60
        var availableSpace = myFrame.height - (height + widthRequired + height + restartButtonHeight)
        availableSpace = availableSpace>0 ? availableSpace: 0
        
        let xRequired = isWidthLess ? 0: (((myFrame.width - widthRequired)/2))
        let yRequired = isWidthLess ? (myFrame.height - widthRequired-110): 0
        let boardRect = CGRect(x: xRequired, y: yRequired, width: widthRequired, height: widthRequired)

        let viewDataModel = ViewDataModel(ratio: ratio, width: widthRequired)
        self.viewModel = MillsGameViewModel(coinPositionsProvider: viewDataModel)
        self.headerModel = HeaderViewModel(playerIcon: viewModel.currentPlayerCoinModel)

        self.headerView = HeaderView(model: headerModel)
        playerView = UIHostingController(rootView: headerView).view
        stackView.addArrangedSubview(playerView)
        
        // Game board
        gameView = MillsGameView(viewDataModel: viewDataModel, viewModel: viewModel, ratio: ratio)
        viewDataModel.view = gameView
       
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.widthAnchor.constraint(equalToConstant: widthRequired).isActive = true
        gameView.heightAnchor.constraint(equalToConstant: widthRequired).isActive = true
        gameView.viewModel = viewModel
        viewModel.delegate = gameView
        gameView.showAlert = showAlert
        gameView.backgroundColor = UIColor.defaultBG()
        stackView.addArrangedSubview(gameView)

        viewModel.player1.passthroughSubject.sink { millsAndAvailableCoin in
            self.headerView.model.player1.playerCoins = (millsAndAvailableCoin.availableCoins > 0) ? defaultPlayerCoins(imageName: "coin1", range: 0...millsAndAvailableCoin.availableCoins-1) : []
            self.headerView.model.player1.playerMills = (millsAndAvailableCoin.mills > 0) ? defaultPlayerCoins(imageName: "coin2", range: 0...millsAndAvailableCoin.mills-1): []
        }
        .store(in: &disposable)

        viewModel.playerChangeSubject.sink { playerIcon in
            self.headerView.model.playerIcon = CoinModel(imageName: playerIcon)
        }
        .store(in: &disposable)

        viewModel.player2.passthroughSubject.sink { millsAndAvailableCoin in
            self.headerView.model.player2.playerCoins = (millsAndAvailableCoin.availableCoins > 0) ? defaultPlayerCoins(imageName: "coin2", range: 0...millsAndAvailableCoin.availableCoins-1) : []

            self.headerView.model.player2.playerMills = (millsAndAvailableCoin.mills > 0) ? defaultPlayerCoins(imageName: "coin1", range: 0...millsAndAvailableCoin.mills-1): []
        }
        .store(in: &disposable)
        
//        setShadow(view: playerView)
//        setShadow(view: gameView)
//        setCornerRadius(view: playerView)
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
}

protocol CoinProvider {
    func provideCoinPositions(with buttonSelected: @escaping (CoinPosition)->Void ) -> [CoinPosition]
}

