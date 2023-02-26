//
//  LaunchScreenViewController.swift
//  KidsLove
//
//  Created by Babblu Bhaiya on 25/02/23.
//

import UIKit
import SwiftUI

class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        let width = guide.layoutFrame.size.width
        makeViews(height: height, width: width)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Present the next view controller here
            self.navigationController?.pushViewController(OperatorsViewController(), animated: true)
        }
        
    }
    private func makeViews(height:CGFloat, width: CGFloat){
        @State var dragAmount = CGSize.zero
        @State  var enabled = false
        let letters = Array("Hello SwiftUI ♥")
        let myViewWidth = width * 0.2
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: myViewWidth, height: myViewWidth))
        let myView1 = UIView(frame: CGRect(x: width - myViewWidth, y: 0, width: myViewWidth, height: myViewWidth))
        let myView2 = UIView(frame: CGRect(x: 0, y: height - myViewWidth, width: myViewWidth, height: myViewWidth))
        let myView3 = UIView(frame: CGRect(x: width - myViewWidth, y: height - myViewWidth, width: myViewWidth, height: myViewWidth))
    
        
        let image1 = UIImageView(frame: CGRect(x: 0, y: 0, width: myViewWidth, height: myViewWidth))
        image1.image = UIImage(named: "1-removebg-preview")
        image1.contentMode = .scaleAspectFit
        
        let image2 = UIImageView(frame: CGRect(x: 0, y: 0, width: myViewWidth, height: myViewWidth))
        image2.image = UIImage(named: "2-removebg-preview")
        image2.contentMode = .scaleAspectFit
        
        let image3 = UIImageView(frame: CGRect(x: 0, y: 0, width: myViewWidth, height: myViewWidth))
        image3.image = UIImage(named: "multiply-removebg-preview")
        image3.contentMode = .scaleAspectFit
        
        let image4 = UIImageView(frame: CGRect(x: 0, y: 0, width: myViewWidth, height: myViewWidth))
        image4.image = UIImage(named: "4-removebg-preview")
        image4.contentMode = .scaleAspectFit
        
        myView.backgroundColor = UIColor.white
        myView.addSubview(image1)
        myView.layer.cornerRadius = 30
        
        myView1.backgroundColor = UIColor.white
        myView1.addSubview(image2)
        myView1.layer.cornerRadius = 30
        
        myView2.backgroundColor = UIColor.white
        myView2.addSubview(image3)
        myView2.layer.cornerRadius = 30
        
        myView3.backgroundColor = UIColor.white
        myView3.addSubview(image4)
        myView3.layer.cornerRadius = 30
        
      
        view.addSubview(myView)
        view.addSubview(myView1)
        view.addSubview(myView2)
        view.addSubview(myView3)
       
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .curveLinear], animations: {
            myView.center.x = self.view.center.x - (myViewWidth / 2)
            myView.center.y = self.view.center.y - (myViewWidth / 2)
            myView1.center.x = self.view.center.x + (myViewWidth / 2)
            myView1.center.y = self.view.center.y - (myViewWidth / 2)
            myView2.center.x = self.view.center.x - (myViewWidth / 2)
            myView2.center.y = self.view.center.y + (myViewWidth / 2)
            myView3.center.x = self.view.center.x + (myViewWidth / 2)
            myView3.center.y = self.view.center.y + (myViewWidth / 2)
        }, completion: nil)
        
    }
    
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


