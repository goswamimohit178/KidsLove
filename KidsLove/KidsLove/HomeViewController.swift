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
        present(OperatorsViewController(), animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mathButton.layer.cornerRadius = 0.5 * mathButton.bounds.size.width
        engButton.layer.cornerRadius = 0.5 * engButton.bounds.size.width
        
       
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
