//
//  Model.swift
//  KidsLove
//
//  Created by Vikash on 08/02/23.


import Foundation

struct SubjectModel {
    var math: [Unit]
}

struct Unit {
    var unitNumber: String
    var chapterName: String
    var levels: [LevelCellModel]
}

struct LevelCellModel {
    var progress: Progress
    let title: String
    let oprator: Oprator
    let noOfOprands: Int
    let levelType: LevelType
  
    func questions() -> [Question] {
        return NetworkService()
            .getQuestions(range: levelType.range, numberOfOptions: 4, numberOfQuestions: AppConfig().numberOfQuestions , oprator: oprator, noOfOprands: noOfOprands)
    }
}
struct Question {
    let questionText: String
    let answer: [Int]
    let correctAnswer: Int
}
enum Progress: Int {
    case zero
    case oneThird
    case twoThird
    case complete
    var progress: Float {
        switch self {
        case .zero:
            return 0.0
        case .oneThird:
            return 0.33
        case .twoThird:
            return 0.66
        case .complete:
            return 1.0
        }
    }
}
enum LevelType: Int {
    case easy
    case medium
    case hard
    case practice

    var range: ClosedRange<Int> {
        switch self {
        case .easy:
            return 1...9
        case .medium:
            return 9...20
        case .hard:
            return 20...50
        case .practice:
            return 10...40
        }
    }
}
