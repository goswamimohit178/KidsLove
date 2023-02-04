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
    
    @IBOutlet weak var option2btn: UIButton!
    
    @IBOutlet weak var option3Btn: UIButton!
    
    @IBOutlet weak var option4Btn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var oprand1Label: UILabel!
    
    @IBOutlet weak var operatorLabel: UILabel!
    
    @IBOutlet weak var oprand2Label: UILabel!
    
    var continueButtonCounter = 1
    @IBAction func continueButton(_ sender: Any) {
        //loadNextQuestion()
        if continueButtonCounter == questions.count{
            let resultVC = ResultsViewController()
            resultVC.correctAnswer = noCorrect
            resultVC.totalMarks = questions.count
           present(resultVC, animated: true)
        } else {
            let model = questions[continueButtonCounter]
            setQuestions(model: model)
            currentQuestion = model
            continueButtonCounter += 1
        }
        
    }
    
    
    @IBAction func choice1Select(_ sender: Any) {
        
        checkAnswer(idx: 0)
    }
    @IBAction func choice2Select(_ sender: Any) {
        checkAnswer(idx: 1)
    }
    
    @IBAction func choice3Select(_ sender: Any) {
        checkAnswer(idx: 2)
    }
    
    @IBAction func choice4Select(_ sender: Any) {
        checkAnswer(idx: 3)
    }
    
    
    
    
    var currentQuestion: Model?
    var currentQuestionPosition: Int = 0
    var noCorrect: Int = 0
    var questions: [Model] = [
    Model(num1: 12, num2: 13, operation: "+", answer: [21,41,51,25], correctAnswer: 3),
    Model(num1: 97, num2: 41, operation: "-", answer: [43,33,56,54], correctAnswer: 2),
    Model(num1: 66, num2: 3, operation: "×", answer: [198,345,43,222], correctAnswer: 0),
    Model(num1: 18, num2: 6, operation: "÷", answer: [2,33,4,3], correctAnswer: 3)
    ]
    func checkAnswer(idx: Int) {
        if (currentQuestion!.correctAnswer == idx) {
            noCorrect += 1
        }
    }
    
    
   
    
    func setQuestions(model: Model){
        
        oprand1Label.text = String(model.num1)
        oprand2Label.text = String(model.num2)
        operatorLabel.text = String(model.operation)
        option1Btn.setTitle(String(model.answer[0]), for: .normal)
        option2btn.setTitle(String(model.answer[1]), for: .normal)
        option3Btn.setTitle(String(model.answer[2]), for: .normal)
        option4Btn.setTitle(String(model.answer[3]), for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let model = questions[0]
        currentQuestion = questions[0]
        setQuestions(model: model)
        option1Btn.btnCorner()
        option2btn.btnCorner()
        option3Btn.btnCorner()
        option4Btn.btnCorner()
        continueBtn.btnCorner()
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

