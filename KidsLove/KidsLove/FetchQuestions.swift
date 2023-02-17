//
//  FetchQuestions.swift
//  KidsLove
//
//  Created by Vikash on 12/02/23.
//

import Foundation
class NetworkService {
    let defaults = UserDefaults.standard
    
    func getQuestions(range: ClosedRange<Int>, numberOfOptions: Int, numberOfQuestions: Int, oprator: Oprator, noOfOprands: Int) -> [Question] {
        var easyQuestionList = [Question]()
        for _ in 0...numberOfQuestions {
            let question = getQuestion(range: range, numberOfOptions: numberOfOptions, oprator: oprator, noOfOprands: noOfOprands)
            easyQuestionList.append(question)
        }
        return easyQuestionList
    }
    
    func getQuestion(range: ClosedRange<Int>, numberOfOptions: Int, oprator: Oprator, noOfOprands: Int) -> Question {
        let (questionString, answer, optionArray) = getQuestionAnswerOptions(range, oprator: oprator, noOfOprands: noOfOprands, numberOfOptions: numberOfOptions)
        
        let shuffledArray = optionArray.shuffled()
        return Question(questionText: "\(questionString) = ?", answer: shuffledArray, correctAnswer: shuffledArray.firstIndex(of: answer)!)
    }
    
    fileprivate func getOptions(_ numberOfOptions: Int, _ answer: Int) -> [Int] {
        var optionArray: [Int] = []
        optionArray.append(answer)
        while optionArray.count < numberOfOptions {
            let option = random(digits: answer.size())
            if !optionArray.contains(option) {
                optionArray.append(option)
            }
        }
        return optionArray
    }
    
    fileprivate func getQuestionAnswerOptions( _ range: ClosedRange<Int>, oprator: Oprator, noOfOprands: Int, numberOfOptions: Int)  -> (String, Int, [Int]) {
        let (questionString, answer) = getQuestionAnswer(range, oprator: oprator, noOfOprands: noOfOprands)
       
        let optionArray = getOptions(numberOfOptions, answer)
        return (questionString, answer, optionArray)
    }
    
    private func getQuestionAnswer( _ range: ClosedRange<Int>, oprator: Oprator, noOfOprands: Int) -> (String, Int){
        var questionString = ""
        var answer: Int = oprator.getInitialValueOfAnswer()
        var oprandsArray = [Int]()

        for _ in 1...noOfOprands {
            if oprator == .division , !questionString.isEmpty {
                let option = generateRandomNumber(range: range)
                let num = answer * option
                questionString = String(num) + oprator.getOperator() + questionString
                answer = option
            } else {
                let range = answer...oprator.upperBound(upperBound: range.upperBound)
                let num = generateRandomNumber(range: range)
                if questionString.isEmpty {
                    questionString += String(num)
                    answer = num
                } else {
                    questionString = String(num) + oprator.getOperator() + questionString
                    answer = oprator.calculateAnswer(num1: num, num2: answer)
                }
                oprandsArray.append(num)
            }
        }
        return (questionString, answer)
    }
    
    private func getUnit(unitNumber: Int, oprator: Oprator) -> Level {
        let easyMultiplyprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelType: .easy)
        let mediumMultiplyprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelType: .medium)
        let hardMultiplyprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelType: .hard)
        let practiceProgress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelType: .practice)
        
        let easyMultiplyCellModel = LevelCellModel(progress: easyMultiplyprogress, title: "Easy", oprator: oprator , noOfOprands: 2, levelType: .easy)
        let mediumMultiplyCellModel = LevelCellModel(progress: mediumMultiplyprogress, title: "Medium", oprator: oprator, noOfOprands: 2, levelType: .medium)
        let hardMultiplyCellModel = LevelCellModel(progress: hardMultiplyprogress, title: "Hard", oprator: oprator, noOfOprands: 2, levelType: .hard)
        let chainLevelCellModel = LevelCellModel(progress: practiceProgress, title: "Practice", oprator: oprator, noOfOprands: 3, levelType: .practice)
        
        return Level(easyLevel: easyMultiplyCellModel,  hardLevel: hardMultiplyCellModel, mediumLevel: mediumMultiplyCellModel, chainsLevel: chainLevelCellModel)
        
    }
    func setLevelWise() -> [Unit] {
        return  [
            Unit(unitNumber: "Unit 1", chapterName: "Multiplication", levels:  getUnit(unitNumber: 0, oprator: .multiplication)),
            
            Unit(unitNumber: "Unit 2", chapterName: "Division", levels: getUnit(unitNumber: 1, oprator: .division)),
            Unit(unitNumber: "Unit 3", chapterName: "Addition", levels: getUnit(unitNumber: 2, oprator: .addition)),
            Unit(unitNumber: "Unit 4", chapterName: "Subtraction", levels: getUnit(unitNumber: 3, oprator: .subtraction))
        ]
    }
    func getProgressFromUserDefault(currentUnitNumber: Int, currentLevelType: LevelType) -> Progress {
        let keyForProgrss: String = "\(currentUnitNumber)-\(currentLevelType)"
        let progress = defaults.value(forKey: keyForProgrss) as? Int ?? 0
        
        return Progress(rawValue: progress) ?? .zero
    }
    
    func generateRandomNumber(range: ClosedRange<Int>) -> Int{
        return Int.random(in: range)
    }
    
    func random(digits:Int) -> Int {
        let min = Int(pow(Double(10), Double(digits-1))) - 1
        let max = Int(pow(Double(10), Double(digits))) - 1
        return generateRandomNumber(range: min...max)
    }
}

extension Int {
    func size() -> Int {
        var size = 1
        var modifyingNumber = self
        while modifyingNumber > 10 {
            modifyingNumber = modifyingNumber / 10
            size = size + 1
        }
        return size
    }

}

enum Oprator {
    case multiplication
    case division
    case addition
    case subtraction
    
    func getInitialValueOfAnswer() -> Int {
        switch self {
        case .division, .multiplication :
            return 1
        default:
            return 0
        }
    }
    func calculateAnswer(num1: Int,num2: Int) -> Int {
        switch self {
        case .multiplication :
            return num1 * num2
        case .division:
            return num1 / num2
        case .addition:
            return num1 + num2
        case .subtraction:
            return num1 - num2
        }
    }
    func getOperator() -> String {
        switch self {
        case .multiplication:
            return "×"
        case .division:
            return "÷"
        case .addition:
            return "+"
        case .subtraction:
            return "-"
        }
    }
    func upperBound(upperBound: Int) -> Int{
        switch self {
        case .multiplication, .division:
            return 10
        case .addition:
            return upperBound
        case .subtraction:
            return upperBound
        }
    }
}



