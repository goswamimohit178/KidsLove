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
//        UIView.animate(withDuration: 0.5, animations: {
//            self.mathButton.transform = self.mathButton.transform.scaledBy(x: 0.8, y: 0.8)
//        }) { _ in
//            UIView.animate(withDuration: 0.5, animations: {
//                self.mathButton.transform = self.mathButton.transform.translatedBy(x: 150, y: 50)
//          }) { _ in
//
//          }
//        }
    }
    
    @IBAction func engButtubTapped(_ sender: Any) {
//        UIView.animate(withDuration: 0.5, animations: {
//            self.engButton.transform = self.engButton.transform.scaledBy(x: 0.8, y: 0.8)
//        }) { _ in
//            UIView.animate(withDuration: 0.5, animations: {
//                self.engButton.transform = self.engButton.transform.translatedBy(x: -150, y: -250)
//          }) { _ in
//
//          }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mathButton.layer.cornerRadius = 0.5 * mathButton.bounds.size.width
        engButton.layer.cornerRadius = 0.5 * engButton.bounds.size.width
//        animate(button: self.mathButton)
//        animate(button: self.engButton)
        buttonAnimation(button: mathButton)
        buttonAnimation(button: engButton)
        
        
    }
//    private func animate(button: UIButton) {
//        let animator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) { [unowned self, button] in
//           button.transform = CGAffineTransform(rotationAngle: 0).scaledBy(x: 2, y: 2)
//        }
//        animator.startAnimation()
//        UIView.animate(withDuration: 1, delay: 1, animations: {
//            button.transform = CGAffineTransform(rotationAngle: 0).scaledBy(x: 1, y: 1)
//        })
//
//    }
//    func animateButton() {
//        mathButton.transform = CGAffineTransform(translationX: mathButton.frame.origin.x, y: mathButton.frame.origin.y)
//        UIView.animate(withDuration: 1.5, delay: 0.0, options: [], animations: {
//            self.mathButton.transform = .identity
//        }, completion: nil)
//    }
    private func buttonAnimation(button: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            button.transform = button.transform.scaledBy(x: 0.8, y: 0.8)
        }) { _ in
            if button == self.mathButton {
                UIView.animate(withDuration: 0.5, animations: {
                    self.mathButton.transform = self.mathButton.transform.translatedBy(x: 150, y: 50)
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.engButton.transform = self.engButton.transform.translatedBy(x: -150, y: -250)
                })
                {_ in
                }
            }
        }
    }
}
