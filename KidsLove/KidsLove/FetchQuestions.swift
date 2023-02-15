//
//  FetchQuestions.swift
//  KidsLove
//
//  Created by Vikash on 12/02/23.
//

import Foundation
class NetworkService {
    let defaults = UserDefaults.standard
     func getQuestions(range: ClosedRange<Int>, numberOfOptions: Int, numberOfQuestions: Int, oprator: String, noOfOprands: Int) -> [Question] {
        var easyQuestionList = [Question]()
        for _ in 0...numberOfQuestions {
            var optionArray: [Int] = []
            var oprandsArray = [Int]()
            var answer: Int = 1
            var questionString: String = ""
            for index in 1...noOfOprands {
                let num = generateRandomNumber(range: range)
                oprandsArray.append(num)
                if index == noOfOprands {
                    questionString += String(num)
                } else {
                    questionString += String(num) + " " + oprator + " "
                }
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
                easyQuestionList.append(Question(questionText: "\(questionString) = ?", answer: shuffledArray, correctAnswer: shuffledArray.firstIndex(of: answer)!))
                }
        return easyQuestionList
    }
    
    private func getUnit(unitNumber: Int) -> Level {
        let easyMultiplyprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelType: .easy)
        let mediumMultiplyprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelType: .medium)
        let hardMultiplyprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelType: .hard)
        let easyMultiplyCellModel = LevelCellModel(progress: easyMultiplyprogress, title: "Easy", oprator: "×", noOfOprands: 2, levelType: .easy)
        let mediumMultiplyCellModel = LevelCellModel(progress: mediumMultiplyprogress, title: "Medium", oprator: "×", noOfOprands: 3, levelType: .medium)
        let hardMultiplyCellModel = LevelCellModel(progress: hardMultiplyprogress, title: "Hard", oprator: "×", noOfOprands: 2, levelType: .hard)
        
        return Level(easyLevel: easyMultiplyCellModel,  hardLevel: hardMultiplyCellModel, mediumLevel: mediumMultiplyCellModel, chainsLevel: easyMultiplyCellModel)
    }
    
    func setLevelWise() -> [Unit] {
             return  [
                Unit(unitNumber: "Unit 1", chapterName: "Multiplication", levels: getUnit(unitNumber: 0)),
                Unit(unitNumber: "Unit 2", chapterName: "Shapes", levels: getUnit(unitNumber: 1)),
                Unit(unitNumber: "Unit 3", chapterName: "Division", levels: getUnit(unitNumber: 2)),
                Unit(unitNumber: "Unit 4", chapterName: "Fractions", levels: getUnit(unitNumber: 3)),
                Unit(unitNumber: "Unit 5", chapterName: "Measurement", levels: getUnit(unitNumber: 4)),
                Unit(unitNumber: "Unit 6", chapterName: "Decimals", levels: getUnit(unitNumber: 5)),
                Unit(unitNumber: "Unit 7", chapterName: "Review", levels: getUnit(unitNumber: 6))
        ]
    }
    private func getProgressFromUserDefault(currentUnitNumber: Int, currentLevelType: LevelType) -> Progress {
        let keyForProgrss: String = "\(currentUnitNumber)-\(currentLevelType)"
        let progress = defaults.value(forKey: keyForProgrss) as? Int ?? 0
    
        return Progress(rawValue: progress) ?? .zero
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
