//
//  ViewController.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 03/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func controllerbtn(_ sender: Any) {
     //   self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    @IBOutlet weak var showButtonTapped: UIButton!
    
    @IBAction func showButtonTappped(_ sender: Any) {
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
      
    }


}

