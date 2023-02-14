//
//  HomeViewController.swift
//  KidsLove
//
//  Created by Vikash on 03/02/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var mathButton: UIButton!
    @IBOutlet var engButton: UIButton!
    
    @IBOutlet weak var mathTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mathLeadingConstraint: NSLayoutConstraint!
   
    
    @IBOutlet weak var engLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var engTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var engWidthConstraint: NSLayoutConstraint!
    var buttonHeight = 100.0
    @IBAction func mathButtonTapped(_ sender: Any) {
        
        self.navigationController?.pushViewController(OperatorsViewController(), animated: true)
    }
   
    @IBAction func engButtubTapped(_ sender: Any) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonHeight = view.frame.width * 0.4
        engWidthConstraint.constant = buttonHeight
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setButtonsHome()
        buttonAnimation(button: mathButton)
    }
    private func setButtonsHome() {
        mathButton.layer.cornerRadius = 0.5 * mathButton.bounds.size.width
        engButton.layer.cornerRadius = 0.5 * engButton.bounds.size.width
        mathButton.titleLabel?.font = UIFont.myAppBodyFonts()
        engButton.titleLabel?.font =  UIFont.myAppBodyFonts()
        mathButton.backgroundColor = UIColor.homeButtonColor()
        
    }
    private func buttonAnimation(button: UIButton) {
        self.mathTopConstraint.constant = (self.view.frame.height / 2.0)  - (self.buttonHeight / 2)
        let halfXPoint = self.view.frame.width/2
        let leadingSpace = (halfXPoint - self.buttonHeight) / 2
        self.mathLeadingConstraint.constant = halfXPoint + leadingSpace
        
        self.engTopConstraint.constant = self.mathTopConstraint.constant
        self.engLeadingConstraint.constant = (halfXPoint - buttonHeight)/2
        UIView.animate(withDuration: 0.8, animations: {
            self.view.layoutIfNeeded()
        });

   }
}
