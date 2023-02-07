//
//  OperatorsViewController.swift
//  KidsLove
//
//  Created by Vikash on 03/02/23.
//

import UIKit

class OperatorsViewController: UIViewController {
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBAction func plusBtnTapped(_ sender: Any) {
    self.navigationController?.pushViewController(QuestionViewController(), animated: true)
    }
    
    @IBAction func minusBtnTapped(_ sender: Any) {
        self.navigationController?.pushViewController(QuestionViewController(), animated: true)
    }
    
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonOperators()
        
        buttonAnimation(button: plusButton)
        buttonAnimation(button: divideButton)
        buttonAnimation(button: productButton)
        buttonAnimation(button: minusButton)
    }
    
    private func setButtonOperators() {
        plusButton.layer.cornerRadius = 0.5 * plusButton.bounds.size.width
        divideButton.layer.cornerRadius = 0.5 * divideButton.bounds.size.width
        productButton.layer.cornerRadius = 0.5 * productButton.bounds.size.width
        minusButton.layer.cornerRadius = 0.5 * minusButton.bounds.size.width
        myView.layer.cornerRadius = 0.05 * myView.bounds.size.width
        plusButton.titleLabel?.font = UIFont.myAppBodyFonts()
        divideButton.titleLabel?.font = UIFont.myAppBodyFonts()
        productButton.titleLabel?.font = UIFont.myAppBodyFonts()
        minusButton.titleLabel?.font = UIFont.myAppBodyFonts()
        plusButton.backgroundColor = UIColor.homeButtonColor()
        divideButton.backgroundColor = UIColor.homeButtonColor()
        productButton.backgroundColor = UIColor.homeButtonColor()
        minusButton.backgroundColor = UIColor.homeButtonColor()
        
    }
    
    private func buttonAnimation(button: UIButton) {
        UIView.animate(withDuration: 1, animations: {
            button.transform = button.transform.scaledBy(x: 1.2, y: 1.2)
        })
        if button == self.plusButton {
            UIView.animate(withDuration: 1, animations: {
                self.plusButton.transform = self.plusButton.transform.translatedBy(x: 0, y: 274)
            })
        } else if button == self.divideButton  {
            UIView.animate(withDuration: 1, animations: {
                self.divideButton.transform = self.divideButton.transform.translatedBy(x: 0, y: -274)
            })
        } else if button == self.productButton  {
            UIView.animate(withDuration: 1, animations: {
                self.productButton.transform = self.productButton.transform.translatedBy(x: 200, y: 0)
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.minusButton.transform = self.minusButton.transform.translatedBy(x: -200, y: 0)
            })
        }
    }
}


