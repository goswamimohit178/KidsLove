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
    @IBOutlet weak var starStackView: UIStackView!
    
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!

    var correctAnswer: Int = 0
    var totalMarks: Int = 0
    var progress: Progress = .zero
    var opratorVC: OperatorsViewController!
    var currentUnitNumber: Int!
    var currentLevelNumber: Int!
    var percentage: Float!
    let defaults = UserDefaults.standard
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        opratorVC.showQuestionsFor(unitNumber: currentUnitNumber, levelNumber: currentLevelNumber+1)
    }
    
    @IBAction func tryAgainBtnTapped(_ sender: Any) {
        opratorVC.showQuestionsFor(unitNumber: currentUnitNumber, levelNumber: currentLevelNumber)
    }
    
    @IBAction func goToHomeButton(_ sender: Any) {
        self.navigationController?.popToViewController(opratorVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontAndColorResults()
        if var viewControllers = navigationController?.viewControllers {
            viewControllers.remove(at: viewControllers.count-2)
            navigationController?.viewControllers = viewControllers
        }

        let resultprogress = calculateResultProgress()
        percentage = Float(correctAnswer) / Float(totalMarks) * 100.0
        replaceStarsImages(percentage: percentage)
     
        resultProgressBar.setProgress(resultprogress.0, animated: true)
        resultProgressBar.tintColor = UIColor.progressBarColor()
        if resultprogress.1 == .complete {
            goToNextLevelButton.isEnabled = true
        } else {
            goToNextLevelButton.isEnabled = false
            goToNextLevelButton.backgroundColor = UIColor.buttonBackgroundColor()
        }
    }
    
    private func replaceStarsImages(percentage: Float) {
        if percentage >= 80 {
            starImageView1.image = UIImage(named: "filled-star")
            starImageView2.image = UIImage(named: "filled-star")
            starImageView3.image = UIImage(named: "filled-star")
        } else if percentage >= 45 && percentage <= 80 {
            starImageView1.image = UIImage(named: "filled-star")
            starImageView2.image = UIImage(named: "filled-star 1")
            starImageView3.image = UIImage(named: "filled-star (1)")?.withTintColor(UIColor.starsTintColor())
        } else {
            starImageView1.image = UIImage(named: "filled-star")
            starImageView2.image = UIImage(named: "filled-star (1)")?.withTintColor(UIColor.starsTintColor())
            starImageView3.image = UIImage(named: "filled-star (1)")?.withTintColor(UIColor.starsTintColor())
        }
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
        let key = "\(currentUnitNumber!)-\(currentLevelNumber!)"
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
        opratorVC.setProgess(progress: currentProgress, unitNumber: currentUnitNumber, levelNumber: currentLevelNumber)
        let keyForProgrss: String = "\(currentUnitNumber!)-\(currentLevelNumber!)"
        print(keyForProgrss)
        defaults.set(currentProgress.rawValue, forKey: keyForProgrss)
    }
    private func calculateResultProgress() -> (Float, Progress) {
        let previousProgress = getPreviousProgress()
        let currentProgress = calculateCurrentProgress(previousProgress: previousProgress)
        setNewProgress(currentProgress: currentProgress)
        switch currentProgress {
        case .zero:
            return (0.0, .complete)
        case .oneThird:
            return (0.3, .oneThird)
        case .twoThird:
            return (0.66, .twoThird)
        case .complete:
            return (1, .complete)
        }
    }
}
