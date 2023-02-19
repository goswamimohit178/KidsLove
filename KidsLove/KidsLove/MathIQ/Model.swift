//
//  Model.swift
//  KidsLove
//
//  Created by Vikash on 08/02/23.


import Foundation

enum Game: Int {
    case TwoZeroFourEight
    case Mills
        
    var title: String {
        switch self {
        case .TwoZeroFourEight:
            return "2048"
        case .Mills:
            return "Mills"
        }
    }
}

enum CellType {
    case game(game: Game)
    case math(progress: Progress, oprator: Oprator, noOfOprands: Int, levelType: LevelType)
    
    var index: Int {
        switch self {
        case .game(game: _):
            return 0
        case .math(progress: _, oprator: _, noOfOprands: _, levelType: let levelType):
            return levelType.rawValue
        }
    }
    
    var mathProgress: Progress {
        switch self {
        case .game(game: _):
            fatalError("Invalid state")
        case .math(progress: let progress, oprator: _, noOfOprands: _, levelType: _):
            return progress
        }
    }
}

struct SubjectModel {
    var math: [Unit]
}

struct Unit {
    var unitNumber: String
    var chapterName: String
    var levels: [LevelCellModel]
}

struct LevelCellModel {
    var type: CellType
    let title: String
    
    func questions() -> [Question] {
        guard case .math(_, let oprator, let noOfOprands, let levelType) = type else {
            fatalError("Invalid state")
        }
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
    case game

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
        case .game:
            return 10...40
        }
    }
}
