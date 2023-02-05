//
//  OperatorsViewController.swift
//  KidsLove
//
//  Created by Vikash on 03/02/23.
//

import UIKit

class OperatorsViewController: UIViewController {

    let btnBackgroundColor = UIColor.heavyGreen()
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
     plusButton.layer.cornerRadius = 0.5 * plusButton.bounds.size.width
        divideButton.layer.cornerRadius = 0.5 * divideButton.bounds.size.width
      productButton.layer.cornerRadius = 0.5 * productButton.bounds.size.width
      minusButton.layer.cornerRadius = 0.5 * minusButton.bounds.size.width
    myView.layer.cornerRadius = 0.05 * myView.bounds.size.width
        plusButton.backgroundColor = btnBackgroundColor
        productButton.backgroundColor = btnBackgroundColor
        minusButton.backgroundColor = btnBackgroundColor
        divideButton.backgroundColor = btnBackgroundColor

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
