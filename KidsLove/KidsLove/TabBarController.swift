//
//  TabBarController.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 19/02/23.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = OperatorsViewController()
        let mathUnites = NetworkService().mathUnites()
        tabOne.model = SubjectModel(math: mathUnites)
        let tabOneBarItem = UITabBarItem(title: "Math", image: UIImage(named: "math"), selectedImage: UIImage(named: "math"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = OperatorsViewController()
        let gameUnites = NetworkService().gameUnites()
        tabTwo.model = SubjectModel(math: gameUnites)
        let tabTwoBarItem2 = UITabBarItem(title: "Game", image: UIImage(named: "gamecontroller"), selectedImage: UIImage(named: "gamecontroller"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        
        self.viewControllers = [tabOne, tabTwo]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("Selected \(viewController.title!)")
    }
}
