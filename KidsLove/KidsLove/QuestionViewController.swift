//
//  QuestionViewController.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 03/02/23.
//

import UIKit
import AVFAudio

class QuestionViewController: UIViewController {
    
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var option1Btn: UIButton!
    @IBOutlet private weak var option2Btn: UIButton!
    @IBOutlet private weak var option3Btn: UIButton!
    @IBOutlet private weak var option4Btn: UIButton!
    @IBOutlet private weak var continueBtn: UIButton!
    @IBOutlet private weak var oprand1Label: UILabel!
    var opratorVC: OperatorsViewController!
    var currentUnitNumber: Int!
    var currentLevelType: LevelType!
    
    
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
        //r̥overrideUserInterfaceStyle = .dark
        continueBtn.titleLabel?.font = UIFont.myAppBodyFonts()
        continueBtn.titleLabel?.tintColor = UIColor.bodyFontColor()
        progressBar.transform = CGAffineTransformMakeScale(1.0, 3.0)
        progressBar.layer.cornerRadius = 30
        let value:Float = Float(1)/Float(questionList.count)
        progressBar.setProgress(value, animated: true)
        progressBar.tintColor = UIColor.progressBarColor()
        
        
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
        let correctAnswerIndex = correctAnsIndex()
        if sender.titleLabel?.text == "Continue" || sender.titleLabel?.text == "View Result" {
            selectedIndex = nil
            goToNextQuestion()
            continueBtn.setTitle("Check", for: .normal)
            continueBtn.backgroundColor = UIColor.buttonBackgroundColor()
            continueBtn.titleLabel?.font = UIFont.myAppBodyFonts()
        } else {
            checkAnswerBtn()
            if selectedIndex == correctAnswerIndex  {
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
    
    
    private func setQuestionFonts() {
        oprand1Label.font = UIFont.myAppBodyFonts()
    }
    
    private func correctAnsIndex() -> Int {
        let currentQuestion = questionList[currentQuestionNumber]
        let correctAnswerIndex = currentQuestion.correctAnswer
        return correctAnswerIndex
    }
    
    private func checkAnswerBtn() {
        guard let selectedIndex = selectedIndex else { return }
        
        let button = optionButtons[selectedIndex]
        if checkAnswer(idx: selectedIndex) {
            button.backgroundColor = UIColor.rightAnswerColor()
            playSound(soundString: "rightButton")
        } else {
            button.backgroundColor = UIColor.wrongAnswerColor()
            playSound(soundString: "wrongButton")
            button.shake()
        }
        isFirstTimeTapped = false
    }
    
    private func goToNextQuestion() {
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
            resultVC.currentLevelType = currentLevelType
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
        if currentModel.correctAnswer == idx {
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
            button.layer.shadowColor = UIColor.btnShadowColor().cgColor
            button.layer.shadowOffset = CGSize(width: 5.0, height: 10)
            button.layer.shadowOpacity = 3.0
            button.layer.shadowRadius = 5.0
            button.layer.masksToBounds = false
            button.layer.cornerRadius = 20
        }
    }
    
    private func resetOptionBtnColor() {
        optionButtons.forEach { $0.backgroundColor = UIColor.buttonBackgroundColor() }
        
        
    }
    
    private func setQuestions(model: Question){
        oprand1Label.text = model.questionText
        
        for (index, button) in optionButtons.enumerated() {
            button.setTitle(String(model.answer[index]), for: .normal)
            
            button.titleLabel?.font = UIFont.myAppBodyFonts()
            button.titleLabel?.tintColor = UIColor.bodyFontColor()
        }
        resetOptionBtnColor()
    }
    
    var player: AVAudioPlayer?
    
    private func playSound(soundString: String) {
        guard let path = Bundle.main.url(forResource: soundString, withExtension: "wav")
            else {
            return }
//        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: path)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
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
