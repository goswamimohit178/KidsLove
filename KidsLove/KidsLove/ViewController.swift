//
//  ViewController.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 03/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func controllerbtn(_ sender: Any) {
        present(QuestionViewController(), animated: true)
    }    
    
    @IBOutlet weak var showButtonTapped: UIButton!
    
    @IBAction func showButtonTappped(_ sender: Any) {
        
        
        present(HomeViewController(), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
      
    }


}

