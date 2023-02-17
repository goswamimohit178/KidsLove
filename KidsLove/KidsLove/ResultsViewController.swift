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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var goToHomeLabel: UIButton!
    @IBOutlet weak var goToNextLevelButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var resultProgressBar: UIProgressView!
    //var currentprogress:
    var correctAnswer: Int = 0
    var totalMarks: Int = 0
    var progress: Progress = .zero
    var opratorVC: OperatorsViewController!
    var currentUnitNumber: Int!
    var currentLevelType: LevelType!
    var percentage: Float!
    let defaults = UserDefaults.standard
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func tryAgainBtnTapped(_ sender: Any) {
        opratorVC.showCurrentLevelQuestions(unitNumber: currentUnitNumber, leveltype: currentLevelType)
    }
    
    @IBAction func goToHomeButton(_ sender: Any) {
        
        self.navigationController?.popToViewController(opratorVC, animated: true)
        
        if percentage >= 80.0 {
            let previousProgress = getPreviousProgress()
            let currentProgress = calculateCurrentProgress(previousProgress: previousProgress)
            setNewProgress(currentProgress: currentProgress)
        }    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontAndColorResults()
        percentage = Float(correctAnswer) / Float(totalMarks) * 100.0
        if var viewControllers = navigationController?.viewControllers {
            viewControllers.remove(at: viewControllers.count-2)
            navigationController?.viewControllers = viewControllers
        }
        let resultprogress = calculateResultProgress()
        resultProgressBar.setProgress(resultprogress, animated: true)
        resultProgressBar.tintColor = UIColor.progressBarColor()
        let vc = UIHostingController(rootView: ContentView())
        
        self.view.addSubview(vc.view)
        vc.view.center = CGPoint(x: view.frame.size.width  / 2,
                                 y: view.frame.size.height / 2)
    }
    private func fontAndColorResults() {
        footerView.layer.cornerRadius = 0.05 * footerView.bounds.size.width
        headerView.layer.cornerRadius = 0.05 * headerView.bounds.size.width
        tryAgainButton.layer.cornerRadius = 0.08 * tryAgainButton.bounds.size.width
        goToNextLevelButton.layer.cornerRadius = 0.08 * goToNextLevelButton.bounds.size.width
        yourScoreLabel.font = UIFont.myAppBodyFonts()
        continueButton.titleLabel?.font = UIFont.myAppBodyFonts()
        headerView.backgroundColor = UIColor.homeButtonColor()
        footerView.backgroundColor = UIColor.homeButtonColor()
        headerLabel.font = UIFont.myAppBodyFonts()
        goToHomeLabel.titleLabel?.font = UIFont.myAppBodyFonts()
        headerLabel.tintColor = UIColor.bodyFontColor()
        goToHomeLabel.tintColor = UIColor.bodyFontColor()
        yourScoreLabel.font = UIFont.myAppBodyFonts()
        yourScoreLabel.tintColor = UIColor.bodyFontColor()
        tryAgainButton.backgroundColor = UIColor.homeButtonColor()
        goToNextLevelButton.backgroundColor = UIColor.homeButtonColor()
        tryAgainButton.titleLabel?.font = UIFont.myAppBodyFonts()
        goToNextLevelButton.titleLabel?.font = UIFont.myAppBodyFonts()
        
    }
    private func getPreviousProgress() -> Progress{
        let key = "\(currentUnitNumber!)-\(currentLevelType!)"
        let rawValue = defaults.value(forKey: key) as? Int ?? 0
        return Progress(rawValue: rawValue) ?? .zero
    }
    private func calculateCurrentProgress(previousProgress: Progress) -> Progress{
        switch previousProgress {
        case .zero:
           return .oneThird
        case .oneThird:
           return .twoThird
        case .twoThird:
            return .complete
        case .complete:
            return .complete
        }
    }
    private func setNewProgress(currentProgress: Progress) {
        opratorVC.setProgess(progress: currentProgress, unitNumber: currentUnitNumber, levelType: currentLevelType)
        let keyForProgrss: String = "\(currentUnitNumber!)-\(currentLevelType!)"
        print(keyForProgrss)
        defaults.set(currentProgress.rawValue, forKey: keyForProgrss)
    }
    private func calculateResultProgress() -> Float{
        let previousProgress = getPreviousProgress()
        let currentProgress = calculateCurrentProgress(previousProgress: previousProgress)
        switch currentProgress {
        case .zero:
            return  0.0
        case .oneThird:
            return 0.3
        case .twoThird:
            return 0.66
        case .complete:
            return 1
        }
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


