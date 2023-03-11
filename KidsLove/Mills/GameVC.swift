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

class GameVC:  UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var gameView: MillsGameView!
    private var playerView: UIView!
    private var disposable = Set<AnyCancellable>()
    var gameMode: PlayWith?
    @Published var headerModel: HeaderViewModel!
    var headerView: HeaderView!
    
    
    var viewModel: MillsGameViewModel!
    
    var myFrame: CGRect {
        let margins = view.safeAreaLayoutGuide
        let myFrame = margins.layoutFrame
        return myFrame
    }
    
    var boardHeight: CGFloat {
        return min(myFrame.width, myFrame.height * 0.60)
    }
    
    var headerHeight: CGFloat {
        return myFrame.height * 0.30
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        print("nameeeeeeeeeeeeeeeeeeeeeeeeee---------------------------------------\(gameMode!)")
    }
    
    func startNewGame() {
        createNewGame()
        setCurrentPlayer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        startNewGame()
    }
    
    func setCurrentPlayer() {
        gameView!.viewModel!.player1Playing = true
    }
    
    fileprivate func cleanup() {
        gameView.removeFromSuperview()
        playerView.removeFromSuperview()
    }
    
    func showAlert(message: String) {
        showAlert(title: "Game over!", message: "Do you want to start a new game?")
    }
    
    fileprivate func createNewGame() {
        let margins = view.safeAreaLayoutGuide
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 5
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true

        // Header view
        ratio = boardHeight/350
        
        let viewDataModel = ViewDataModel(ratio: ratio, width: boardHeight)
        self.viewModel = MillsGameViewModel(coinPositionsProvider: viewDataModel)
        self.headerModel = HeaderViewModel(playerIcon: viewModel.currentPlayerCoinModel)

        self.headerView = HeaderView(model: headerModel, restratAction: restartButtonAction, muteAction: muteButtonAction)


        playerView = UIHostingController(rootView: headerView).view
        stackView.addArrangedSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
//        playerView.backgroundColor = .red

        // Game board
        gameView = MillsGameView(viewDataModel: viewDataModel, viewModel: viewModel, ratio: ratio)
        viewDataModel.view = gameView
//        gameView.backgroundColor = .blue

        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.widthAnchor.constraint(equalToConstant: boardHeight).isActive = true
        gameView.heightAnchor.constraint(equalToConstant: boardHeight).isActive = true
        
        gameView.viewModel = viewModel
        viewModel.delegate = gameView
        gameView.showAlert = showAlert
        gameView.backgroundColor = UIColor.defaultBG()
        stackView.addArrangedSubview(gameView)
        
        viewModel.player1.passthroughSubject.sink { millsAndAvailableCoin in
            self.headerView.model.player1.playerCoins = (millsAndAvailableCoin.availableCoins > 0) ? defaultPlayerCoins(imageName: "coin1", range: 0...millsAndAvailableCoin.availableCoins-1) : []
            self.headerView.model.player2.playerMills = (millsAndAvailableCoin.mills > 0) ? defaultPlayerCoins(imageName: "coin1", range: 0...millsAndAvailableCoin.mills-1): []
        }
        .store(in: &disposable)
        
        viewModel.playerChangeSubject.sink { playerIcon in
            self.headerView.model.playerIcon = CoinModel(imageName: playerIcon, offset: 0)
        }
        
        .store(in: &disposable)
        
        viewModel.player2.passthroughSubject.sink { millsAndAvailableCoin in
            self.headerView.model.player2.playerCoins = (millsAndAvailableCoin.availableCoins > 0) ? defaultPlayerCoins(imageName: "coin2", range: 0...millsAndAvailableCoin.availableCoins-1) : []

            self.headerView.model.player1.playerMills = (millsAndAvailableCoin.mills > 0) ? defaultPlayerCoins(imageName: "coin2", range: 0...millsAndAvailableCoin.mills-1): []
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
    
    func restartButtonAction() {
        showAlert(title: "Restart Game!", message: "Are you sure you want to restart?")
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id",
            AnalyticsParameterItemName: "User restarted game",
            AnalyticsParameterContentType: "cont"
        ])
    }
    
    func muteButtonAction() {
        SoundPlayer.isMute.toggle()
//        if isUserOnMute {
//            button.setTitle("Unmute", for: .normal)
//        } else {
//            button.setTitle("Mute", for: .normal)
//        }
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id",
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



