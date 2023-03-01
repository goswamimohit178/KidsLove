//
//  QuestionViewModel.swift
//  KidsLove
//
//  Created by Vikash on 28/02/23.
//

import Foundation
import SwiftUI

struct QuestionViewModel {
    var model: LevelCellModel!
    
    let questionList: [Question]
    let questionText: String
    let answer: [Int]
    let correctAnswer: Int
    var selectedButtonIndex: Int
    var buttonBackgroundColor: Color
    init(model: LevelCellModel) {
        self.model = model
        self.questionList = model.questions()
        self.questionText = questionList[0].questionText
        self.answer = questionList[0].answer
        self.correctAnswer = questionList[0].correctAnswer
        self.buttonBackgroundColor = Color(ThemeManager.themeColor)
        self.selectedButtonIndex = 0
    }
    mutating func optionButtonTapped(optionNumber: Int) {
        selectedButtonColor()
        selectedButtonIndex = optionNumber
    }
    
    func checkAnswer(optionNumber: Int) -> Bool {
        return correctAnswer == optionNumber ? true : false
    }
    func checkButtonTapped() {
        print("check button tapped!")
        if checkAnswer(optionNumber: selectedButtonIndex) {
            print("correct")
        } else {
            print("false!!")
        }
    }
    
    mutating func defaultBackGroundColor() {
        buttonBackgroundColor = Color(ThemeManager.themeColor)
    }
    mutating func selectedButtonColor() {
        buttonBackgroundColor = .blue
    }
}
