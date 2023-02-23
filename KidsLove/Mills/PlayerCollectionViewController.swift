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
	var imageNames = [String]() {
		didSet {
			collectionView.reloadData()
		}
	}

	var collectionView: UICollectionView! {
    didSet {
      self.collectionView!.register(CoinCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
  }
  
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			return imageNames.count
    }

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CoinCollectionViewCell
		cell.coinImage.image =  UIImage(named: imageNames[indexPath.row])
		return cell
	}

}
