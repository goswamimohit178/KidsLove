//
//  FetchQuestions.swift
//  KidsLove
//
//  Created by Vikash on 12/02/23.
//

import Foundation
class NetworkService{
    let defaults = UserDefaults.standard
    fileprivate func getQuestions(range: ClosedRange<Int>, numberOfOptions: Int, numberOfQuestions: Int, oprator: Oprator, noOfOprands: Int) -> [Question] {
        var easyQuestionList = [Question]()
        
        for _ in 0...numberOfQuestions {
            var optionArray: [Int] = []
            var oprandsArray = [Int]()
            var answer: Int = oprator.getInitialValueOfAnswer()
            var questionString: String = ""
            
            if oprator == .division {
                
                var num1: Int = 0
                let num2 = generateRandomNumber(range: range)
        
                while optionArray.count < numberOfOptions {
                    let option = generateRandomNumber(range: 2...10)
                    if !optionArray.contains(option) {
                        optionArray.append(option)
                    }
                }
                answer = optionArray[2]
                num1 = answer * num2
                questionString += String(num1) + " " + "÷" + " " + String(num2)
            } else {
                for index in 1...noOfOprands {
                    let num = generateRandomNumber(range: range)
                    oprandsArray.append(num)
                    if index == noOfOprands {
                        questionString += String(num)
                    } else {
                        questionString += String(num) + " " + oprator.getOperator() + " "
                    }
                    
                    answer = oprator.calculateAnswer(answer: answer, num: num)
                    
                    optionArray.append(answer)
                    while optionArray.count < numberOfOptions {
                        let option = random(digits: answer.size())
                        if !optionArray.contains(option) {
                            optionArray.append(option)
                        }
                    }
                }
            }
                let shuffledArray = optionArray.shuffled()
                easyQuestionList.append(Question(questionText: "\(questionString) = ?", answer: shuffledArray, correctAnswer: shuffledArray.firstIndex(of: answer)!))
            
            
        }
        return easyQuestionList
    }
    func getUnit(unitNumber: Int, oprator: Oprator) -> Level {
        
        let easyQuestionList = getQuestions(range: 1...9, numberOfOptions: 4, numberOfQuestions: 5, oprator: oprator, noOfOprands: 2)
        let mediumQuestionList = getQuestions(range: 10...20, numberOfOptions: 4, numberOfQuestions: 5, oprator: oprator, noOfOprands: 2)
        
        let hardQuestionList  = getQuestions(range: 2...10, numberOfOptions: 4, numberOfQuestions: 5, oprator: oprator, noOfOprands: 3)
        let easyLevelCellModel = LevelCellModel(progress: getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelType: .easy), title: "Easy", questions: easyQuestionList)
        let mediumLevelCellModel = LevelCellModel(progress: getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelType: .medium), title: "Medium", questions: mediumQuestionList)
        let hardLevelCellModel = LevelCellModel(progress: getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelType: .hard), title: "Hard", questions: hardQuestionList)
        
        let chainsLevelCellModel = LevelCellModel(progress: .zero, title: "Chain", questions: [Question]())
        
        return Level(easyLevel: easyLevelCellModel,  hardLevel: hardLevelCellModel, mediumLevel: mediumLevelCellModel, chainsLevel: chainsLevelCellModel)
    }
    
    func setLevelWise() -> [Unit] {
        return  [
            Unit(unitNumber: "Unit 1", chapterName: "Multiplication", levels:  getUnit(unitNumber: 0,oprator: .multiplication)
                ),
            
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
    func calculateAnswer(answer: Int,num: Int) -> Int {
        switch self {
        case .multiplication :
            return answer * num
        case .division:
            return answer / num
        case .addition:
            return answer + num
        case .subtraction:
            return answer - num
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
}

