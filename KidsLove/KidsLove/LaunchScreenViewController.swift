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
        let screenHeight = screenSize.height
       // let height = screenHeight*0.20
        let animationView = Lottie.LottieAnimationView()
        let animation = Lottie.LottieAnimationView(name: "childAnimation").animation
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.play()
        
       // animationView.backgroundColor = .red
       
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.center = CGPoint(x: view.bounds.size.width/2 , y: view.bounds.size.height/2)
        animationView.widthAnchor.constraint(equalToConstant: screenWidth ).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
//        animationView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
//        animationView.heightAnchor.constraint(equalToConstant: screenWidth).isActive = true
        view.addSubview(animationView)
//        let horizontalConstraint = NSLayoutConstraint(item: animationView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 0.8, constant: 0)
//        let verticalConstraint = NSLayoutConstraint(item: animationView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 0.8, constant: 0)
      
      

        // Do any additional setup after loading the view.
     // tabBarController?.present(OperatorsViewController(), animated: true)

         //  self.navigationController?.pushViewController(TabBarController(), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let nextViewController = TabBarController() // replace this with the view controller you want to show
            UIApplication.shared.windows.first?.rootViewController = nextViewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
    }
    

}
