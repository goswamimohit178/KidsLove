//
//  PlayerCollectionViewController.swift
//  Mills
//
//  Created by vishnu.d on 30/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CoinCollectionViewCell"

class PlayerCollectionViewController:  NSObject, UICollectionViewDataSource {
	var image1Names = [String]() {
		didSet {
            player1CollectionView.reloadData()
		}
	}
    
    var image2Names = [String]() {
        didSet {
            player2CollectionView.reloadData()
        }
    }

    var player2CollectionView: UICollectionView! {
        didSet {
            self.player2CollectionView!.register(CoinCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
    var player1CollectionView: UICollectionView! {
        didSet {
            self.player1CollectionView!.register(CoinCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
  
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == player1CollectionView {
            return image1Names.count
        }
        return image2Names.count
    }

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CoinCollectionViewCell
        if collectionView == player1CollectionView {
            cell.coinImage.image =  UIImage(named: image1Names[indexPath.row])
        } else {
            cell.coinImage.image =  UIImage(named: image2Names[indexPath.row])
        }
		return cell
	}

}
