//
//  TabBarController.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 19/02/23.
//

import UIKit
import SwiftUI
import Lottie

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewControllers = [mathVC, gameVC, settingsVC]
        tabBar.tintColor = UIColor.defaultThemeColor
    }
    
    func themeUpdated() {
        self.viewControllers = [mathVC, gameVC, settingsVC]
        tabBar.tintColor = UIColor.defaultThemeColor
    }
    
    var settingsVC: UIViewController {
        let settingsVC = UIHostingController(rootView: SettingsView(themeUpdated: themeUpdated))
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape"))
        return settingsVC
    }
    
    var mathVC: UIViewController {
        let mathVC = OperatorsViewController()
        let navigationVC = UINavigationController(rootViewController: mathVC)
        let mathUnites = NetworkService().mathUnites()
        mathVC.model = SubjectModel(math: mathUnites)
        mathVC.tabBarItem = UITabBarItem(title: "Math", image: UIImage(named: "math"), selectedImage: UIImage(named: "math"))
        return navigationVC
    }
    
    var gameVC: UIViewController {
        let gameVC = OperatorsViewController()
        let navigationVC = UINavigationController(rootViewController: gameVC)
        let gameUnites = NetworkService().gameUnites()
        gameVC.model = SubjectModel(math: gameUnites)
        gameVC.tabBarItem = UITabBarItem(title: "Game", image: UIImage(systemName: "gamecontroller"), selectedImage: UIImage(systemName: "gamecontroller"))
        return navigationVC
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("Selected \(viewController.title!)")
    }
}
