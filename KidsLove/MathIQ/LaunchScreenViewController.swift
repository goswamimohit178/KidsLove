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
        view.backgroundColor = UIColor.defaultBG()
        let animationView = LottieAnimationView(name: "teacher")
        animationView.loopMode = .loop
        view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let nextViewController = TabBarController() // replace this with the view controller you want to show
            
            let foregroundedScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            let window = foregroundedScenes.map { $0 as? UIWindowScene }.compactMap { $0 }.first?.windows.filter { $0.isKeyWindow }.first
            
            guard let uWindow = window else { return }
            
            uWindow.rootViewController = nextViewController
            UIView.transition(with: uWindow, duration:0.8, options: [.transitionCrossDissolve], animations: {}, completion: nil)
        }
    }
    
}
