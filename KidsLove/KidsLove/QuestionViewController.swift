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
    @IBOutlet private weak var operatorLabel: UILabel!
    @IBOutlet private weak var oprand2Label: UILabel!
    
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
    
    private let customButtonTitle = NSMutableAttributedString(string: "Check", attributes: [
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 38.0),
        //        NSAttributedString.Key.backgroundColor: UIColor.red,
        NSAttributedString.Key.foregroundColor: UIColor.blue
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addOptionButtons()
        setupModel()
        setCornerRadius()
        
    }
    
    fileprivate func setCornerRadius() {
        optionButtons.forEach { $0.btnCorner() }
        continueBtn.btnCorner()
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
        var correctAnswerIndex = correctAnsIndex()
        if sender.titleLabel?.text == "Continue" {
            selectedIndex = nil
            goToNextQuestion()
            continueBtn.setTitle("Check", for: .normal)
            continueBtn.backgroundColor = .lightGray
        } else  {
            checkAnswerBtn()
            if selectedIndex == correctAnswerIndex  {
                continueBtn.setTitle("Continue", for: .normal)

                //                continueBtn.backgroundColor = .green
            }
        }
    }
    
    private func correctAnsIndex() -> Int {
        let currentQuestion = questions[currentQuestionNumber]
        let correctAnswerIndex = currentQuestion.correctAnswer
        return correctAnswerIndex
    }
    
    private func checkAnswerBtn() {
        guard let selectedIndex = selectedIndex else { return }
        
        let button = optionButtons[selectedIndex]
        //      correctOptionButton.backgroundColor = .green
        
        if checkAnswer(idx: selectedIndex) {
            button.backgroundColor = .green
            playSound(soundString: "rightButton")
            
        } else {
            button.backgroundColor = .red
            playSound(soundString: "wrongButton")
        }
        isFirstTimeTapped = false
    }
    
    private func goToNextQuestion() {
        currentQuestionNumber += 1
        let value = Float(currentQuestionNumber)/Float(questions.count)
        progressBar.setProgress(value, animated: true)
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
        optionButtons[selectedIndex!].backgroundColor = .blue
        continueBtn.isEnabled = true
        continueBtn.backgroundColor = .green
        
        
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
        
        
        //        optionButtons.forEach { $0.isDisabled = false }
        
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
    
    private func resetOptionBtnColor() {
        optionButtons.forEach { $0.backgroundColor = .lightGray }
        
    }
    
    private func setQuestions(model: Model){
        oprand1Label.text = String(model.num1)
        oprand2Label.text = String(model.num2)
        operatorLabel.text = String(model.operation)
        for (index, button) in optionButtons.enumerated() {
            button.setTitle(String(model.answer[index]), for: .normal)
        }
        resetOptionBtnColor()
    }
    
    var player: AVAudioPlayer?
    
    func playSound(soundString: String) {
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
    func btnCorner() {
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .lightGray
    }
}

struct Model {
    let num1:Int
    let num2:Int
    let operation: String
    let answer: [Int]
    let correctAnswer: Int
}
