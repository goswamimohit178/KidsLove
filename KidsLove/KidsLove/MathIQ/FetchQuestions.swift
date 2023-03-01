//
//  FetchQuestions.swift
//  KidsLove
//
//  Created by Vikash on 12/02/23.
//

import Foundation
class NetworkService {
    let defaults = UserDefaults.standard
    
    func getOddOnesQuestions() -> [Question] {
        let data = findOddOneOutJson.data(using: .unicode)!
        return try! JSONDecoder().decode([Question].self, from: data)
    }
    
    func getQuestions(range: ClosedRange<Int>, numberOfOptions: Int, numberOfQuestions: Int, oprator: Oprator, noOfOprands: Int) -> [Question] {
        var easyQuestionList = [Question]()
        for _ in 1...numberOfQuestions {
            var question = getQuestion(range: range, numberOfOptions: numberOfOptions, oprator: oprator, noOfOprands: noOfOprands)

            while easyQuestionList.map({ $0.answer }).contains(question.answer) || easyQuestionList.map({ $0.questionText }).contains(question.questionText) {
                question = getQuestion(range: range, numberOfOptions: numberOfOptions, oprator: oprator, noOfOprands: noOfOprands)
            }
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
                questionString = String(num) + " " + oprator.getOperator() + " " + questionString
                answer = option
            } else {
                let upperBound = oprator.upperBound(upperBound: range.upperBound)
                var tempRange = range
                if answer <= upperBound {
                    tempRange = answer...upperBound
                }
                let num = generateRandomNumber(range: tempRange)
                if questionString.isEmpty {
                    questionString += String(num)
                    answer = num
                } else {
                    questionString = String(num) + " " + oprator.getOperator() + " " + questionString
                    answer = oprator.calculateAnswer(num1: num, num2: answer)
                }
                oprandsArray.append(num)
            }
        }
        return (questionString, answer)
    }
    
    private func getOddOneLevels(unitNumber: Int) -> [LevelCellModel] {
        let easyprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelNumber: 0)
        let mediumprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelNumber: 1)
        let hardprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelNumber: 2)
        let practiceProgress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelNumber: 3)
        
        let easyCellModel =  LevelCellModel(type: .math(progress: easyprogress, oprator: .oddOne, noOfOprands: 2, levelType: .easy), title: "Easy")
       
        let mediumCellModel = LevelCellModel(type: .math(progress: mediumprogress, oprator: .oddOne, noOfOprands: 2, levelType: .medium), title: "Medium")
        
        let hardCellModel = LevelCellModel(type: .math(progress: hardprogress, oprator: .oddOne, noOfOprands: 2, levelType: .hard), title: "Hard")
        let praticeCellModel = LevelCellModel(type: .math(progress: practiceProgress, oprator: .oddOne, noOfOprands: 3, levelType: .practice), title: "Practice")

        return [easyCellModel, mediumCellModel, hardCellModel, praticeCellModel]
    }

    private func getLevels(unitNumber: Int, oprator: Oprator) -> [LevelCellModel] {
        let easyprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelNumber: 0)
        let mediumprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelNumber: 1)
        let hardprogress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelNumber: 2)
        let practiceProgress = getProgressFromUserDefault(currentUnitNumber: unitNumber, currentLevelNumber: 3)
        
        let easyCellModel =  LevelCellModel(type: .math(progress: easyprogress, oprator: oprator, noOfOprands: 2, levelType: .easy), title: "Easy")
       
        let mediumCellModel = LevelCellModel(type: .math(progress: mediumprogress, oprator: oprator, noOfOprands: 2, levelType: .medium), title: "Medium")
        
        let hardCellModel = LevelCellModel(type: .math(progress: hardprogress, oprator: oprator, noOfOprands: 2, levelType: .hard), title: "Hard")
        let praticeCellModel = LevelCellModel(type: .math(progress: practiceProgress, oprator: oprator, noOfOprands: 3, levelType: .practice), title: "Practice")

        return [easyCellModel, mediumCellModel, hardCellModel, praticeCellModel]
        
    }
    
    func mathUnites() -> [Unit] {
        return  [
            Unit(unitNumber: "Unit 1", chapterName: "Addition", levels: getLevels(unitNumber: 0, oprator: .addition)),
            Unit(unitNumber: "Unit 2", chapterName: "Subtraction", levels: getLevels(unitNumber: 1, oprator: .subtraction)),
            Unit(unitNumber: "Unit 3", chapterName: "Multiplication", levels:  getLevels(unitNumber: 2, oprator: .multiplication)),
            Unit(unitNumber: "Unit 4", chapterName: "Division", levels: getLevels(unitNumber: 3, oprator: .division)),
            Unit(unitNumber: "Unit 5", chapterName: "Odd ones", levels: getOddOneLevels(unitNumber: 4)),
        ]
    }
    
    func gameUnites() -> [Unit] {
        let twoZeroFourEight = LevelCellModel(type: .game(game: .TwoZeroFourEight), title: "2048")
        let mills = LevelCellModel(type: .game(game: .Mills), title: "Mills")
        return  [
            Unit(unitNumber: "Games", chapterName: "Number Games", levels: [twoZeroFourEight]),
            Unit(unitNumber: "Other Games", chapterName: "Mind game", levels: [mills])
        ]
    }
    
    func getProgressFromUserDefault(currentUnitNumber: Int, currentLevelNumber: Int) -> Progress {
        let keyForProgrss: String = "\(currentUnitNumber)-\(currentLevelNumber)"
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
    private func generateOptionArray(optionArray: inout [Int], numberOfOptions: Int,range: ClosedRange<Int>) -> [Int]{
        while optionArray.count < numberOfOptions {
            let option = generateRandomNumber(range: range)
            if !optionArray.contains(option) {
                optionArray.append(option)
            }
        }
        return optionArray
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
    case oddOne
    
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
        case .oddOne:
            fatalError("Invalid state")
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
        case .oddOne:
            return "O"
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
        case .oddOne:
            fatalError("Invalid state")
        }
    }
}

var findOddOneOutJson: String {
    """
[
  {
    "questionText": "Find the odd one out",
    "answer": [
      3,
      5,
      2,
      7
    ],
    "correctAnswer": 2
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      3,
      7,
      15,
      17,
      22,
      27,
      29
    ],
    "correctAnswer": 22
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      5,
      25,
      30,
      34,
      40,
      50,
      65,
      75
    ],
    "correctAnswer": 34
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      8,
      12,
      16,
      21,
      24,
      28,
      32
    ],
    "correctAnswer": 21
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      14,
      17,
      18,
      20,
      22,
      24,
      26
    ],
    "correctAnswer": 17
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      53,
      59,
      62,
      67,
      71,
      73,
      79
    ],
    "correctAnswer": 62
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      3,
      5,
      11,
      14,
      17,
      21
    ],
    "correctAnswer": 14
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      10,
      25,
      45,
      54,
      60,
      75,
      80
    ],
    "correctAnswer": 54
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      6,
      9,
      15,
      21,
      24,
      28,
      30
    ],
    "correctAnswer": 28
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      6,
      12,
      18,
      24,
      34
    ],
    "correctAnswer": 34
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      23,
      25,
      27,
      29,
      30
    ],
    "correctAnswer": 30
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      35,
      45,
      55,
      65,
      75,
      86
    ],
    "correctAnswer": 86
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      1,
      4,
      9,
      16,
      23,
      25,
      36
    ],
    "correctAnswer": 23
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      1,
      4,
      9,
      16,
      20,
      36,
      49
    ],
    "correctAnswer": 20
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      2,
      5,
      10,
      17,
      26,
      37,
      50,
      64
    ],
    "correctAnswer": 64
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      10,
      14,
      16,
      18,
      21,
      24,
      26
    ],
    "correctAnswer": 21
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      16,
      25,
      36,
      72,
      144,
      196,
      225
    ],
    "correctAnswer": 72
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      3,
      5,
      7,
      12,
      17,
      19
    ],
    "correctAnswer": 12
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      41,
      43,
      47,
      53,
      61,
      71,
      73,
      81
    ],
    "correctAnswer": 81
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      331,
      482,
      551,
      263,
      383,
      362,
      284
    ],
    "correctAnswer": 383
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      11,
      22,
      44,
      88,
      177
    ],
    "correctAnswer": 177
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      45,
      9,
      64,
      10,
      75,
      12,
      97,
      17
    ],
    "correctAnswer": 17
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      51,
      64,
      78,
      91,
      104,
      117
    ],
    "correctAnswer": 78
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      147,
      125,
      103,
      81,
      58,
      36,
      14
    ],
    "correctAnswer": 58
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      5,
      15,
      45,
      137,
      411,
      1233
    ],
    "correctAnswer": 137
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      17,
      21,
      26,
      30,
      34,
      38,
      42
    ],
    "correctAnswer": 26
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      22,
      33,
      47,
      55,
      66,
      77,
      88
    ],
    "correctAnswer": 47
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      14,
      28,
      40,
      54,
      68,
      82,
      96
    ],
    "correctAnswer": 40
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      110,
      111,
      222,
      333,
      444
    ],
    "correctAnswer": 110
  },
  {
    "questionText": "Find the odd one out",
    "answer": [
      121,
      196,
      225,
      361,
      355
    ],
    "correctAnswer": 355
  }
]
"""
}
