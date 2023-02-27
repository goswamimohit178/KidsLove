//
//  PlayerView.swift
//  Mills
//
//  Created by vishnu.d on 28/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import UIKit
import Foundation

//clasrew: UIView {
//    private var kvoToken = [NSKeyValueObservation]()
//    @IBOutlet weak var profilePhoto: UIImageView!
//
//    @IBOutlet weak var player1CollectionView: UICollectionView!
//    @IBOutlet weak var player2CollectionView: UICollectionView!
//
//    var availableCoinsCollectionViewController: PlayerCollectionViewController!{
//        didSet {
//            availableCoinsCollectionViewController.player1CollectionView = player1CollectionView
//            availableCoinsCollectionViewController.player2CollectionView = player2CollectionView
//            player1CollectionView.dataSource = availableCoinsCollectionViewController
//            player2CollectionView.dataSource = availableCoinsCollectionViewController
//        }
//    }
//
//    fileprivate func loadPlayer1CoinsCollectionView() {
//        var image1Names = [String]()
//        for _ in 0..<player1.playerRemainingPositions {
//            image1Names.append(player1.coinIcon)
//        }
//
//        if player2 != nil {
//            for _ in 0..<player2.playerChars {
//                image1Names.append(player2.coinIcon)
//            }
//        }
//
//        availableCoinsCollectionViewController.image1Names = image1Names
//    }
//
//    fileprivate func loadPlayer2CoinsCollectionView() {
//        var image2Names = [String]()
//        for _ in 0..<player2.playerRemainingPositions {
//            image2Names.append(player2.coinIcon)
//        }
//        if player1 != nil {
//            for _ in 0..<player1.playerChars {
//                image2Names.append(player1.coinIcon)
//            }
//        }
//        availableCoinsCollectionViewController.image2Names = image2Names
//    }
//
//    var player1: Player! {
//        didSet {
//            observe(player: player1)
//            loadPlayer1CoinsCollectionView()
//        }
//    }
//
//    var player2: Player! {
//        didSet {
//            observe(player: player2)
//            loadPlayer2CoinsCollectionView()
//        }
//    }
//
//
//	class func instanceFromNib(ratio: CGFloat) -> UIView {
//    let view = UINib(nibName: "PlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PlayerView
//    view.layer.borderWidth = 4
//    view.layer.borderColor = UIColor.white.cgColor
//    view.layer.cornerRadius = 15
//		view.backgroundColor = .darkGray
//    view.setShadow(view: view)
//    view.availableCoinsCollectionViewController = PlayerCollectionViewController()
//		view.isUserInteractionEnabled = false
//		let fontSize = ratio < 2 ? ratio*13 : 2*13
////		view.messageLabel.font = UIFont.systemFont(ofSize: fontSize)
//    return view
//  }
//
//  func setShadow(view: UIView) {
//    view.layer.shadowColor = UIColor.black.cgColor
//    view.layer.shadowOffset = CGSize(width: 3, height: 3)
//    view.layer.shadowOpacity = 0.7
//    view.layer.shadowRadius = 10.0
//  }
//
//  func imageView(_ player: Player) -> UIImageView {
//    let imageView = UIImageView()
//    imageView.contentMode = .scaleAspectFit
//    imageView.image = UIImage(named: player.coinIcon)
//    return imageView
//  }
//
//  func observeOpponent(player: Player) {
//      kvoToken.append(player.observe(\.playerChars, options: .new) { (player, change) in
//          self.loadPlayer1CoinsCollectionView()
//          self.loadPlayer2CoinsCollectionView()
//
//      })
//  }
//
//	func animateMessage() {
////		messageLabel.shakeView()
//	}
//
//
//	func observe(player: Player) {
//        kvoToken.append(player.observe(\.isPlaying, options: .new) { [self] (player, change) in
//            self.stopAnimation(view: self.profilePhoto)
//			if player1.isPlaying {
//                self.profilePhoto.image = UIImage(named: self.player1.coinIcon)
//			} else {
//                self.profilePhoto.image = UIImage(named: self.player2.coinIcon)
//			}
//            self.animateView(view: self.profilePhoto)
//            self.loadPlayer1CoinsCollectionView()
//            self.loadPlayer2CoinsCollectionView()
//
//		})
//
////		kvoToken.append(player.observe(\.playerRemainingPositions, options: .new) { (player, change) in
//////            self.loadPlayer1CoinsCollectionView()
//////            self.loadPlayer2CoinsCollectionView()
////		})
//
//		kvoToken.append(player.observe(\.animateMessage, options: .new) { (player, change) in
//			self.animateMessage()
//		})
//
//		kvoToken.append(player.observe(\.messageForUser, options: .new) { (player, change) in
////			self.messageLabel.text = player.messageForUser
//		})
//
//	}
//
//	fileprivate func glowAnimation(_ animDuration: CGFloat, _ view: UIView) {
//		let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
//		layerAnimation.fromValue = UIColor.red.cgColor
//		layerAnimation.toValue = UIColor.green.cgColor
//		layerAnimation.autoreverses = true
//		layerAnimation.isAdditive = true
//		layerAnimation.duration = CFTimeInterval(animDuration/2)
//		layerAnimation.fillMode = CAMediaTimingFillMode.removed
//		layerAnimation.isRemovedOnCompletion = true
//		layerAnimation.repeatCount = .infinity
//		view.layer.add(layerAnimation, forKey: "glowingAnimation")
//	}
//
//	fileprivate func transformAnimation(_ animDuration: CGFloat, _ view: UIView) {
//		UIView.animate(withDuration: TimeInterval(animDuration), delay: 0, options: [.repeat, .autoreverse], animations: {
//			view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
//		}, completion: { _ in
//			view.transform = CGAffineTransform(scaleX: 1, y: 1)
//		})
//	}
//
//	func animateView(view: UIView) {
//		let animDuration : CGFloat = 2
////		let cornerRadius: CGFloat = view.frame.width/2
//		let cornerRadius: CGFloat = 25
//		view.layer.cornerRadius = cornerRadius
//		view.layer.shadowPath = CGPath(roundedRect: view.bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
//		view.layer.shadowOffset = CGSize.zero
//		view.layer.shadowOpacity = 0.33
//		view.layer.shadowColor = UIColor.clear.cgColor
//		view.layer.shadowColor = UIColor.systemBlue.cgColor
//		self.backgroundColor = .lightGray
//		glowAnimation(animDuration, view)
//		transformAnimation(animDuration, view)
//		view.shakeView()
//	}
//
//  func stopAnimation(view: UIView) {
//		view.layer.shadowColor = UIColor.clear.cgColor
//		self.backgroundColor = .clear
//		view.layer.removeAllAnimations()
//  }
//
//
//  deinit {
//    kvoToken.forEach { $0.invalidate() }
//  }
//
//}

extension UIView {
    func shakeView(duration: CGFloat = 0.4) {
			let animation = CAKeyframeAnimation()
			animation.keyPath = "position.x"
			animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
			animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
			animation.duration = duration
			animation.isAdditive = true
			animation.isRemovedOnCompletion = true
		  self.layer.add(animation, forKey: "shake")
	}
}

