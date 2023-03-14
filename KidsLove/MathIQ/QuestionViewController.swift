//
//  QuestionViewController.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 03/02/23.
//

import UIKit
import SwiftUI
import AVFAudio
import Lottie
class QuestionViewController: UIViewController {
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var option1Btn: UIButton!
    @IBOutlet private weak var option2Btn: UIButton!
    @IBOutlet private weak var option3Btn: UIButton!
    @IBOutlet private weak var option4Btn: UIButton!
    @IBOutlet private weak var continueBtn: UIButton!
    @IBOutlet private weak var oprand1Label: UILabel!
    @IBOutlet private weak var questionStackView: UIStackView!
    @IBOutlet private weak var questionImageView: UIImageView!
    @IBOutlet weak var woodenLEadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var blackboard: UIStackView!
    @IBOutlet weak var blackBoardOutlet: UIImageView!
    @IBOutlet weak var questionLable: UILabel!
    
    var opratorVC: OperatorsViewController!
    var currentUnitNumber: Int!
    var currentLevelNumber: Int!
    private var currentQuestionNumber = 0
    private var noCorrect: Int = 0
    private var selectedIndex: Int? = nil
    private var isFirstTimeTapped: Bool = true
    private var optionButtons = [UIButton]()
    var questionList: [Question]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addOptionButtons()
        setQuestionFonts()
        setupModel()
        setCornerRadius()
        setOptionButtonsShadow()
        setOwlAnimation()
        //r̥overrideUserInterfaceStyle = .dark
        continueBtn.titleLabel?.font = UIFont.myAppBodyFonts()
        continueBtn.titleLabel?.tintColor = UIColor.bodyFontColor()
        progressBar.transform = CGAffineTransformMakeScale(1.0, 3.0)
        progressBar.layer.cornerRadius = 30
        let value:Float = Float(1)/Float(questionList.count)
        progressBar.setProgress(value, animated: true)
        progressBar.tintColor = UIColor.progressBarColor()
        //        questionStackView.layer.borderWidth = 10
        questionImageView.setShadowAndCornerRadius(cornerRadius: 20)
        questionStackView.setShadowAndCornerRadius(cornerRadius: 20)
        //        questionImageView.layer.cornerRadius = 20
        //        questionStackView.layer.cornerRadius = 20
        //        questionStackView.clipsToBounds = true
        //        questionStackView.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "My Title"
//        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonTapped))
//        navigationItem.rightBarButtonItem = settingsButton

        navigationController?.navigationBar.backgroundColor = .red
        navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func setCornerRadius() {
        optionButtons.forEach { $0.btnCorner() }
        continueBtn.btnCorner()
        continueBtn.titleLabel?.font = UIFont.myAppBodyFonts()
    }
    
    fileprivate func setupModel() {
        let model = questionList[0]
        setQuestions(model: model)
    }
    
    fileprivate func addOptionButtons() {
        optionButtons.append(option1Btn)
        optionButtons.append(option2Btn)
        optionButtons.append(option3Btn)
        optionButtons.append(option4Btn)
    }
    
    @IBAction private func continueButton(_ sender: UIButton) {
        let correctAnswer = correctAnswer()
        
        if sender.titleLabel?.text == "Continue" || sender.titleLabel?.text == "View Result" {
            selectedIndex = nil
            resetOptionBtnColor()
            goToNextQuestion()
            continueBtn.setTitle("Check", for: .normal)
            continueBtn.backgroundColor = UIColor.buttonBackgroundColor()
            
            continueBtn.titleLabel?.font = UIFont.myAppBodyFonts()
        } else {
            checkAnswerBtn()
            if let selectedIndex = selectedIndex {
                let selectedOption = selectedOption(selectedIndex: selectedIndex)
                if selectedOption == correctAnswer  {
                    if currentQuestionNumber+1 == questionList.count {
                        continueBtn.setTitle("View Result", for: .normal)
                    } else {
                        continueBtn.setTitle("Continue", for: .normal)
                    }
                    
                    continueBtn.backgroundColor = UIColor.selectBtnColor()
                    
                    continueBtn.setNeedsLayout()
                    continueBtn.titleLabel?.font = UIFont.myAppBodyFonts()
                }
            }
        }
    }
    
    private func setQuestionFonts() {
        oprand1Label.font = UIFont.headingFonts()
    }
    
    private func correctAnswer() -> String {
        let currentQuestion = questionList[currentQuestionNumber]
        let correctAnswer = currentQuestion.correctAnswer
        return correctAnswer
    }
    
    private func selectedOption(selectedIndex: Int) -> String {
        let currentQuestion = questionList[currentQuestionNumber]
        let selectedOption = currentQuestion.answer[selectedIndex]
        return selectedOption
    }
    
    private func checkAnswerBtn() {
        guard let selectedIndex = selectedIndex else { return }
        
        let button = optionButtons[selectedIndex]
        
        if checkAnswer(idx: selectedIndex) {
            button.backgroundColor = UIColor.rightAnswerColor()
            button.setTitleColor(.black, for: .normal)
            SoundPlayer().playSound(soundString: "rightButton")
        } else {
            button.backgroundColor = UIColor.wrongAnswerColor()
            SoundPlayer().playSound(soundString: "wrongButton")
            button.shake()
        }
        isFirstTimeTapped = false
    }
    
    private func goToNextQuestion() {
        setOwlAnimation()
        enableAll()
        currentQuestionNumber += 1
        let value:Float = Float(currentQuestionNumber+1)/Float(questionList.count)
        progressBar.setProgress(value, animated: true)
        progressBar.tintColor = UIColor.progressBarColor()
        
        if currentQuestionNumber == questionList.count {
            let resultVC = ResultsViewController()
            resultVC.correctAnswer = noCorrect
            resultVC.totalMarks = questionList.count
            resultVC.opratorVC = opratorVC
            resultVC.currentUnitNumber = currentUnitNumber
            resultVC.currentLevelNumber = currentLevelNumber
            navigationController?.pushViewController(resultVC, animated: true)
        } else {
            let model = questionList[currentQuestionNumber]
            setQuestions(model: model)
        }
        isFirstTimeTapped = true
        
    }
    
    @IBAction private func choice4Select(_ sender: UIButton) {
        setTappedbtnFalse()
        selectedIndex = sender.tag
        resetOptionBtnColor()
        optionButtons[selectedIndex!].backgroundColor = UIColor.selectBtnColor()
        
        
        continueBtn.isEnabled = true
    }
    
    private func setTappedbtnFalse() {
        selectedIndex = nil
        
    }
    private func setAllDisableBtn() {
        optionButtons.forEach { $0.isEnabled = false }
    }
    private func enableAll() {
        optionButtons.forEach { $0.isEnabled = true }
    }
    
    private func disabledAll() {
        if optionButtons.isEmpty {
            optionButtons.forEach { $0.isEnabled = true }
        } else {
            setTappedbtnFalse()
        }
    }
    
    private func checkAnswer(idx: Int) -> Bool {
        let currentModel = questionList[currentQuestionNumber]
        let selectedOption = selectedOption(selectedIndex: idx)

        if currentModel.correctAnswer == selectedOption {
            if isFirstTimeTapped{
                noCorrect += 1
            }
            setAllDisableBtn()
            return true
        }
        return false
    }
    
    private func setOptionButtonsShadow() {
        optionButtons.forEach { button in
            button.setShadow()
        }
    }
    
    private func setOwlAnimation() {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let height = screenHeight*0.17
        let animationView = Lottie.LottieAnimationView()
        let animation = Lottie.LottieAnimationView(name: "panchi").animation
        animationView.animation = animation
        animationView.play()
        view.addSubview(animationView)
        animationView.contentMode = .scaleToFill
        animationView.centerYAnchor.constraint(equalTo: self.blackBoardOutlet.centerYAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor, constant: 0).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: height*2).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: height).isActive = true
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func resetOptionBtnColor() {
        optionButtons.forEach { button in
            button.backgroundColor = UIColor.buttonBackgroundColor()
            button.setTitleColor(UIColor.defaultTextColor(), for: .normal)
        }
    }
    
    private func setQuestions(model: Question){
        //        self.oprand1Label.text = nil
        oprand1Label.shakeView(duration: 1)
        let animation2: CATransition = CATransition()
        animation2.duration = 0.3
        animation2.type = .push
        animation2.timingFunction = CAMediaTimingFunction(name: .easeOut)
        oprand1Label.layer.add(animation2, forKey: "changeTextTransition")
        self.oprand1Label.text = model.questionText
        
        for (index, button) in optionButtons.enumerated() {
            button.setTitle(String(model.answer[index]), for: .normal)
            
            button.titleLabel?.font = UIFont.myAppBodyFonts()
            button.titleLabel?.tintColor = UIColor.bodyFontColor()
        }
        resetOptionBtnColor()
    }
    
}

extension UIButton {
    func btnCorner(cornerRadius: CGFloat = 20) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        backgroundColor = UIColor.buttonBackgroundColor()
    }
}
extension UIView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
