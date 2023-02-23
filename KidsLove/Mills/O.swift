//
//  AppDelegate.swift
//  Mills
//
//  Created by vishnu.d on 26/03/21.
//  Copyright © 2021 Mills Maker. All rights reserved.
//

import UIKit
import CoreData
import Firebase

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let rootViewController = storyboard.instantiateViewController(withIdentifier: "GameVC")
		self.window = UIWindow.init()
		self.window?.bounds = UIScreen.main.bounds
		self.window?.rootViewController = rootViewController
		self.window?.makeKeyAndVisible()
    return true
  }

}

