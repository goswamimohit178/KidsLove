//
//  FetchQuestions.swift
//  KidsLove
//
//  Created by Vikash on 12/02/23.
//

import Foundation
class NetworkService{
    func setLevelWise() -> [Unit] {
        let questionList: [Question] = [
            Question(questionText: "12 × 3 = ?", answer: [26,33,36,31], correctAnswer: 2),
         Question(questionText: "9 × 4 = ?", answer: [43,36,56,54], correctAnswer: 1),
         Question(questionText: "6 × 3 = ?", answer: [18,34,23,22], correctAnswer: 0),
         Question(questionText: "8 × 6 = ?", answer: [28,37,48,38], correctAnswer: 2)
     ]
        let mediumQuestionList: [Question] = [
            Question(questionText: "60 × 7 = ?", answer: [400,420,520,720], correctAnswer: 1),
            Question(questionText: "33 × 7 = ?", answer: [400,420,231,731], correctAnswer: 2),
            Question(questionText: "40 × 7 = ?", answer: [400,420,280,720], correctAnswer: 2),
            Question(questionText: "5 × 55 = ?", answer: [275,285,239,710], correctAnswer: 0)
        ]
        
        let hardQuestionList: [Question] =  [
            Question(questionText: "88 × 2 × 5 = ??", answer: [882,880,870,881], correctAnswer: 1),
            Question(questionText: "90 × 3 × 7 = ??", answer: [1882,1880,1890,1881], correctAnswer: 2),
            Question(questionText: "69 × 6 × 4 = ??", answer: [1682,1656,1670,1881], correctAnswer: 1),
            Question(questionText: "89 × 7 × 9 = ??", answer: [5601,5602,5607,5606], correctAnswer: 2)
        ]
        
        let easyLevelCellModel = LevelCellModel(progress: .zero, title: "Easy", questions: questionList)
        let mediumLevelCellModel = LevelCellModel(progress: .zero, title: "Medium", questions: mediumQuestionList)
        let hardLevelCellModel = LevelCellModel(progress: .zero, title: "Hard", questions: hardQuestionList)
        let chainsLevelCellModel = LevelCellModel(progress: .zero, title: "Chain", questions: [Question]())
        let roundingLevelCellModel = LevelCellModel(progress: .zero, title: "Rounding", questions: [Question]())
        let reviewLevelCellModel = LevelCellModel(progress: .zero, title: "Review", questions: [Question]())
        let level = Level(easyLevel: easyLevelCellModel,  hardLevel: hardLevelCellModel, mediumLevel: mediumLevelCellModel, chainsLevel: chainsLevelCellModel, roundingLevel: roundingLevelCellModel, reviewLevel: reviewLevelCellModel)
        
       return  [
            Unit(unitNumber: "Unit 1", chapterName: "Multiplication", levels: level),
            Unit(unitNumber: "Unit 2", chapterName: "Shapes", levels: level),
            Unit(unitNumber: "Unit 3", chapterName: "Division", levels: level),
            Unit(unitNumber: "Unit 4", chapterName: "Fractions", levels: level),
            Unit(unitNumber: "Unit 5", chapterName: "Measurement", levels: level),
            Unit(unitNumber: "Unit 6", chapterName: "Decimals", levels: level),
            Unit(unitNumber: "Unit 7", chapterName: "Review", levels: level)
        ]
        
    }
}
