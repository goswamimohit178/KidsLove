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
    
    
    private var currentQuestionNumber = 0
    private var noCorrect: Int = 0
    private var selectedIndex: Int? = nil
    private var isFirstTimeTapped: Bool = true
    
    private var optionButtons = [UIButton]()
    
    private var questions: [Model] = [
        Model(num1: 12, num2: 13, operation: "+", answer: [21,41,51,25], correctAnswer: 3),
        Model(num1: 97, num2: 41, operation: "-", answer: [43,33,56,54], correctAnswer: 2),
        Model(num1: 66, num2: 3, operation: "×", answer: [198,345,43,222], correctAnswer: 0),
        Model(num1: 18, num2: 6, operation: "÷", answer: [2,33,4,3], correctAnswer: 3)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addOptionButtons()
        setQuestionFonts()
        setupModel()
        setCornerRadius()
        setOptionButtonsShadow()
        continueBtn.titleLabel?.font = UIFont.myAppBodyFonts()
        continueBtn.titleLabel?.tintColor = UIColor.bodyFontColor()
        progressBar.transform = CGAffineTransformMakeScale(1.0, 3.0)
        progressBar.layer.cornerRadius = 50
        
        
    }
    
    fileprivate func setCornerRadius() {
        optionButtons.forEach { $0.btnCorner() }
        continueBtn.btnCorner()
        continueBtn.titleLabel?.font = UIFont.myAppBodyFonts()
    }
    
    fileprivate func setupModel() {
        let model = questions[0]
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
        if sender.titleLabel?.text == "Continue" {
            selectedIndex = nil
            goToNextQuestion()
            continueBtn.setTitle("Check", for: .normal)
            continueBtn.backgroundColor = UIColor.buttonBackgroundColor()
            continueBtn.titleLabel?.font = UIFont.myAppBodyFonts()
        } else {
            checkAnswerBtn()
            if selectedIndex == correctAnswerIndex  {
                continueBtn.setTitle("Continue", for: .normal)
                continueBtn.backgroundColor = UIColor.continueBtnColor()
                continueBtn.setNeedsLayout()
                continueBtn.titleLabel?.font = UIFont.myAppBodyFonts()
            }
        }
    }
    private func setQuestionFonts() {
        oprand1Label.font = UIFont.myAppBodyFonts()
    }
    
    private func correctAnsIndex() -> Int {
        let currentQuestion = questions[currentQuestionNumber]
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
        currentQuestionNumber += 1
        let value:Float = Float(currentQuestionNumber)/Float(questions.count)
        progressBar.setProgress(value, animated: true)
        progressBar.tintColor = UIColor.progressBarColor()
        if currentQuestionNumber == questions.count {
            let resultVC = ResultsViewController()
            resultVC.correctAnswer = noCorrect
            resultVC.totalMarks = questions.count
            navigationController?.pushViewController(resultVC, animated: true)
        } else {
            let model = questions[currentQuestionNumber]
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
    
    private func disabledAll() {
        if optionButtons.isEmpty {
            optionButtons.forEach { $0.isEnabled = true }
        } else {
            setTappedbtnFalse()
        }
    }
    
    private func checkAnswer(idx: Int) -> Bool {
        let currentModel = questions[currentQuestionNumber]
        if currentModel.correctAnswer == idx {
            if isFirstTimeTapped{
                noCorrect += 1
            }
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
    
    private func setQuestions(model: Model){
        oprand1Label.text = String(model.num1) + " " + String(model.operation) + " " + String(model.num2) + " = " + " ?? "
        
        for (index, button) in optionButtons.enumerated() {
            button.setTitle(String(model.answer[index]), for: .normal)
            button.titleLabel?.font = UIFont.myAppBodyFonts()
            button.titleLabel?.tintColor = UIColor.bodyFontColor()
        }
        resetOptionBtnColor()
    }
    
    var player: AVAudioPlayer?
    
    private func playSound(soundString: String) {
        guard let path = Bundle.main.path(forResource: soundString, ofType:"wav") else {
            return }
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
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

struct Model {
    let num1:Int
    let num2:Int
    let operation: String
    let answer: [Int]
    let correctAnswer: Int
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
