//
//  HomeViewController.swift
//  KidsLove
//
//  Created by Vikash on 03/02/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mathButton: UIButton!
    
    
    @IBOutlet weak var engButton: UIButton!
    
    
    @IBAction func mathButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(OperatorsViewController(), animated: true)

    }
    
    @IBAction func engButtubTapped(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mathButton.layer.cornerRadius = 0.5 * mathButton.bounds.size.width
        engButton.layer.cornerRadius = 0.5 * engButton.bounds.size.width
        
       
    }


}
