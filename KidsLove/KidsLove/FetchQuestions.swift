//
//  FetchQuestions.swift
//  KidsLove
//
//  Created by Vikash on 12/02/23.
//

import Foundation
class NetworkService{
    fileprivate func getQuestions(range: ClosedRange<Int>, numberOfOptions: Int, numberOfQuestions: Int, oprator: String, noOfOprands: Int) -> [Question] {
        var easyQuestionList = [Question]()
        for _ in 0...numberOfQuestions {
            var optionArray: [Int] = []
            var oprandsArray = [Int]()
            var answer: Int = 1
            
            for _ in 1...noOfOprands {
                let num = generateRandomNumber(range: range)
                oprandsArray.append(num)
                
                switch oprator {
                   case "×" :
                    answer *= num
                   case "÷" :
                    answer /= num
                   case "+" :
                    answer += num
                   default:
                    answer *= num
                }
            }
            optionArray.append(answer)
            
            while optionArray.count < numberOfOptions {
                let option = random(digits: answer.size())
                if !optionArray.contains(option) {
                    optionArray.append(option)
                }
            }
                let shuffledArray = optionArray.shuffled()
                easyQuestionList.append(Question(questionText: "\(oprandsArray[0]) \(oprator) \(oprandsArray[1]) \(oprator) \(oprandsArray[2])= ?", answer: shuffledArray, correctAnswer: shuffledArray.firstIndex(of: answer)!))
                }
            
            
        return easyQuestionList
    }
    
    func setLevelWise() -> [Unit] {
        let easyQuestionList = getQuestions(range: 1...9, numberOfOptions: 4, numberOfQuestions: 5, oprator: "×", noOfOprands: 3)
        let mediumQuestionList = getQuestions(range: 10...20, numberOfOptions: 4, numberOfQuestions: 5, oprator: "×", noOfOprands: 3)
        
        let hardQuestionList  = getQuestions(range: 20...100, numberOfOptions: 4, numberOfQuestions: 5, oprator: "÷", noOfOprands: 3)
        
        let easyLevelCellModel = LevelCellModel(progress: .zero, title: "Easy", questions: easyQuestionList)
        let mediumLevelCellModel = LevelCellModel(progress: .zero, title: "Medium", questions: mediumQuestionList)
        let hardLevelCellModel = LevelCellModel(progress: .zero, title: "Hard", questions: hardQuestionList)
        let chainsLevelCellModel = LevelCellModel(progress: .zero, title: "Chain", questions: [Question]())
        let roundingLevelCellModel = LevelCellModel(progress: .zero, title: "Rounding", questions: [Question]())
        let reviewLevelCellModel = LevelCellModel(progress: .zero, title: "Review", questions: [Question]())
        let unitOneQues = Level(easyLevel: easyLevelCellModel,  hardLevel: hardLevelCellModel, mediumLevel: mediumLevelCellModel, chainsLevel: chainsLevelCellModel, roundingLevel: roundingLevelCellModel, reviewLevel: reviewLevelCellModel)
        
       return  [
            Unit(unitNumber: "Unit 1", chapterName: "Multiplication", levels: unitOneQues),
            Unit(unitNumber: "Unit 2", chapterName: "Shapes", levels: unitOneQues),
            Unit(unitNumber: "Unit 3", chapterName: "Division", levels: unitOneQues),
            Unit(unitNumber: "Unit 4", chapterName: "Fractions", levels: unitOneQues),
            Unit(unitNumber: "Unit 5", chapterName: "Measurement", levels: unitOneQues),
            Unit(unitNumber: "Unit 6", chapterName: "Decimals", levels: unitOneQues),
            Unit(unitNumber: "Unit 7", chapterName: "Review", levels: unitOneQues)
        ]
        
    }
    private func generateRandomNumber(range: ClosedRange<Int>) -> Int{
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


