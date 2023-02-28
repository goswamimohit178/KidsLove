//
//  LaunchScreenViewController.swift
//  KidsLove
//
//  Created by Babblu Bhaiya on 27/02/23.
//

import UIKit
import Lottie

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        //let screenHeight = screenSize.height
        let screenWidth = screenSize.width
       // let height = screenHeight*0.20
        let animationView = Lottie.LottieAnimationView()
        let animation = Lottie.LottieAnimationView(name: "teacherAnimation").animation
        animationView.animation = animation
        animationView.play()
        view.addSubview(animationView)
        animationView.contentMode = .scaleToFill
       // animationView.backgroundColor = .red
        animationView.translatesAutoresizingMaskIntoConstraints = false
//        let horizontalConstraint = NSLayoutConstraint(item: animationView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 0.8, constant: 0)
//        let verticalConstraint = NSLayoutConstraint(item: animationView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 0.8, constant: 0)
        animationView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: screenWidth).isActive = true
      

        // Do any additional setup after loading the view.
     // tabBarController?.present(OperatorsViewController(), animated: true)

         //  self.navigationController?.pushViewController(TabBarController(), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let nextViewController = TabBarController() // replace this with the view controller you want to show
            self.present(nextViewController, animated: true)
        }
        
    }
    

}
