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
    var levels: Level
}
struct Level {
    var easyLevel: LevelCellModel
    var hardLevel: LevelCellModel
    var mediumLevel: LevelCellModel
    var chainsLevel: LevelCellModel
//    var roundingLevel: LevelCellModel
//    var reviewLevel: LevelCellModel
}
struct LevelCellModel {
    var progress: Progress
    let title: String
    var questions:[Question]
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
enum LevelType {
    case easy
    case medium
    case hard
}
