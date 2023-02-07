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
        buttonAnimation(button: mathButton)
        buttonAnimation(button: engButton)
        
        
    }
    private func buttonAnimation(button: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            button.transform = button.transform.scaledBy(x: 0.8, y: 0.8)
        }); if button == self.mathButton {
                UIView.animate(withDuration: 0.5, animations: {
                    self.mathButton.transform = self.mathButton.transform.translatedBy(x: 150, y: 50)
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.engButton.transform = self.engButton.transform.translatedBy(x: -150, y: -250)
                })
        }
    }
}
