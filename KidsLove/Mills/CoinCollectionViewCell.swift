//
//  CoinCollectionViewCell.swift
//  Mills
//
//  Created by vishnu.d on 30/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import UIKit

class CoinCollectionViewCell: UICollectionViewCell {
  var coinImage = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    coinImage.frame = self.bounds
    addSubview(coinImage)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

}
