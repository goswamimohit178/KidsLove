//
//  QuestionViewController.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 03/02/23.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var option1Btn: UIButton!
    @IBOutlet weak var option2Btn: UIButton!
    @IBOutlet weak var option3Btn: UIButton!
    @IBOutlet weak var option4Btn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var oprand1Label: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var oprand2Label: UILabel!
    
    var isContinueButton = false
    var continueButtonCounter = 1
    var currentQuestion: Model?
    var currentQuestionPosition: Int = 0
    var noCorrect: Int = 0
    private var selectedIndex: Int? = nil

    
    private var optionButtons = [UIButton]()
    
    var questions: [Model] = [
    Model(num1: 12, num2: 13, operation: "+", answer: [21,41,51,25], correctAnswer: 3),
    Model(num1: 97, num2: 41, operation: "-", answer: [43,33,56,54], correctAnswer: 2),
    Model(num1: 66, num2: 3, operation: "×", answer: [198,345,43,222], correctAnswer: 0),
    Model(num1: 18, num2: 6, operation: "÷", answer: [2,33,4,3], correctAnswer: 3)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addOptionButtons()
        setupModel()
        setCornerRadius()
        
    }
    
    fileprivate func setCornerRadius() {
        option1Btn.btnCorner()
        option2Btn.btnCorner()
        option3Btn.btnCorner()
        option4Btn.btnCorner()
        continueBtn.btnCorner()
    }

    fileprivate func setupModel() {
        let model = questions[0]
        currentQuestion = questions[0]
        setQuestions(model: model)
    }
    
    fileprivate func addOptionButtons() {
        optionButtons.append(option1Btn)
        optionButtons.append(option2Btn)
        optionButtons.append(option3Btn)
        optionButtons.append(option4Btn)
    }
    
    @IBAction func continueButton(_ sender: Any) {
        if isContinueButton {
            selectedIndex = nil
            goToNextQuestion()
            isContinueButton = false
            continueBtn.setTitle("Check", for: .normal)
        } else {
            checkAnswerBtn()
            isContinueButton = true
            continueBtn.setTitle("Continue", for: .normal)
        }
    }
    
    func checkAnswerBtn() {
        guard let selectedIndex = selectedIndex else { return }
        let button = optionButtons[selectedIndex]

        if checkAnswer(idx: selectedIndex) {
            button.backgroundColor = .green
        } else {
            button.backgroundColor = .red
        }
    }
    
    func goToNextQuestion() {
        if continueButtonCounter == questions.count{
            let resultVC = ResultsViewController()
            resultVC.correctAnswer = noCorrect
            resultVC.totalMarks = questions.count
            navigationController?.pushViewController(resultVC, animated: true)
        } else {
            let model = questions[continueButtonCounter]
            setQuestions(model: model)
            currentQuestion = model
            continueButtonCounter += 1
        }
    }
    
    @IBAction func choice1Select(_ sender: Any) {
        setTappedbtnFalse()
        selectedIndex = 0
        resetOptionBtnColor()
        option1Btn.backgroundColor = .blue
        
    }
    @IBAction func choice2Select(_ sender: Any) {
        setTappedbtnFalse()
        selectedIndex = 1
        resetOptionBtnColor()
        option2Btn.backgroundColor = .blue
    }
    
    @IBAction func choice3Select(_ sender: Any) {
        setTappedbtnFalse()
        selectedIndex = 2
        resetOptionBtnColor()
        option3Btn.backgroundColor = .blue
    }
    
    @IBAction func choice4Select(_ sender: Any) {
        setTappedbtnFalse()
        selectedIndex = 3
        resetOptionBtnColor()
        option4Btn.backgroundColor = .blue
    }
    
    func setTappedbtnFalse() {
        selectedIndex = nil
    }
    
    func disabledAll() {
        option1Btn.isEnabled = false
        option2Btn.isEnabled = false
        option3Btn.isEnabled = false
        option4Btn.isEnabled = false
    }
    
    func checkAnswer(idx: Int) -> Bool {
        if (currentQuestion!.correctAnswer == idx) {
            noCorrect += 1
            return true
        }
        return false
    }
    
    func resetOptionBtnColor() {
        option1Btn.backgroundColor = .lightGray
        option2Btn.backgroundColor = .lightGray
        option3Btn.backgroundColor = .lightGray
        option4Btn.backgroundColor = .lightGray
    }
   
    func setQuestions(model: Model){
        oprand1Label.text = String(model.num1)
        oprand2Label.text = String(model.num2)
        operatorLabel.text = String(model.operation)
        option1Btn.setTitle(String(model.answer[0]), for: .normal)
        option2Btn.setTitle(String(model.answer[1]), for: .normal)
        option3Btn.setTitle(String(model.answer[2]), for: .normal)
        option4Btn.setTitle(String(model.answer[3]), for: .normal)
        resetOptionBtnColor()
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

