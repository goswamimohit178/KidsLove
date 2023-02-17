//
//  AppRouter.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 17/02/23.
//

import SwiftUI

final class AppRouter {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        UINavigationBar.appearance().tintColor = .homeButtonColor()
        self.navigationController = navigationController
    }

    func themeUpdated() {
        navigationController.viewControllers[0] = OperatorsViewController()
   
    }
    
    func showSettingsScreen() {
        navigationController.pushViewController(UIHostingController(rootView: SettingsView(themeUpdated: themeUpdated)), animated: true)
    }
    
}
