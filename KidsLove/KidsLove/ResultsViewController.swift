//
//  ResultsViewController.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 04/02/23.
//

import UIKit
import SwiftUI
class ResultsViewController: UIViewController {
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var yourMarks: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var totalMarksOfAll: UILabel!
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var goToHomeLabel: UIButton!
    
    @IBOutlet weak var percentageSignLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var fractionViewDivision: UIView!
    var correctAnswer: Int = 0
    var totalMarks: Int = 0
    var progress: Progress = .twoThird
    var opratorVC: OperatorsViewController!
    var currentUnitNumber: Int!
    var currentLevelType: LevelType!
    var percentage: Float!
    
    @IBOutlet weak var percentageLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var percentageSignLableTrailingConstraint: NSLayoutConstraint!
    @IBAction func goToHomeButton(_ sender: Any) {
        
        self.navigationController?.popToViewController(opratorVC, animated: true)
        
        if correctAnswer > 2 {
            opratorVC.setProgess(progress: .complete, unitNumber: currentUnitNumber, levelType: currentLevelType)
        }
 
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fontAndColorResults()
        self.yourMarks.text = String((Float(correctAnswer) / Float(totalMarks)) * 100.0)
        self.percentageLabel.text = "%"
        labelAnimation()
        if var viewControllers = navigationController?.viewControllers {
            viewControllers.remove(at: viewControllers.count-2)
            navigationController?.viewControllers = viewControllers
        }
        
        let vc = UIHostingController(rootView: ContentView())
        
        self.view.addSubview(vc.view)
        vc.view.center = CGPoint(x: view.frame.size.width  / 2,
                                 y: view.frame.size.height / 2)
        
    }
    private func fontAndColorResults() {
        footerView.layer.cornerRadius = 0.05 * footerView.bounds.size.width
        headerView.layer.cornerRadius = 0.05 * headerView.bounds.size.width
        yourMarks.font = UIFont.myAppBodyFonts()
        yourScoreLabel.font = UIFont.myAppBodyFonts()
        percentageLabel.font = UIFont.myAppBodyFonts()
        continueButton.titleLabel?.font = UIFont.myAppBodyFonts()
        headerView.backgroundColor = UIColor.homeButtonColor()
        footerView.backgroundColor = UIColor.homeButtonColor()
        headerLabel.font = UIFont.myAppBodyFonts()
        goToHomeLabel.titleLabel?.font = UIFont.myAppBodyFonts()
        headerLabel.tintColor = UIColor.bodyFontColor()
        goToHomeLabel.tintColor = UIColor.bodyFontColor()
        
    }
    private func labelAnimation() {
        self.percentageLeadingConstraint.constant = (view.frame.width / 2.0) - (yourMarks.bounds.width)
        self.percentageSignLableTrailingConstraint.constant = (view.frame.width / 2.0) - (percentageSignLabel.bounds.width)
        UIView.animate(withDuration: 0.8, animations: {
            self.view.layoutIfNeeded()
        });
   }
}
struct ContentView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.pink)
                .frame(width: 10, height: 10)
                .modifier(ParticlesModifier())
                .offset(x: -100, y : -50)
            
            Circle()
                .fill(Color.orange)
                .frame(width: 10, height: 10)
                .modifier(ParticlesModifier())
                .offset(x: 50, y : 60)
            
        }
    }
}
struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 3.0
    @State private var radius = 2
    //private var opacity = 0.25
    
    
    func body(content: Content) -> some View {
        ZStack {
            
            ForEach(0..<80, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration-time) / duration))
                Circle().fill(Color.yellow)
                    .hueRotation(Angle(degrees: time * 200))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration-time) / duration))
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 1.0
                self.radius += 1
                
            }
        }
    }
    func calculateRandom() -> CGFloat {
        return CGFloat(Int.random(in: 30..<150))
    }
}

struct FireworkParticlesGeometryEffect : GeometryEffect {
    var time : Double
    var speed = Double.random(in: 20 ... 200)
    var direction = Double.random(in: -Double.pi ...  Double.pi)
    
    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * time
        let yTranslation = speed * sin(direction) * time
        let affineTranslation =  CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
    
    
    
}


