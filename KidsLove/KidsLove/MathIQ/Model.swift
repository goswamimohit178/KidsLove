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

struct MathModel {
    let progress: Progress
    let oprator: Oprator
    let noOfOprands: Int
    let levelType: LevelType
    
}

enum CellType {
    case game(game: Game)
    case math(mathModel: MathModel)
    
    var index: Int {
        switch self {
        case .game(game: _):
            return 0
        case .math(let model):
            return model.levelType.rawValue
        }
    }
    
    var mathProgress: Progress {
        switch self {
        case .game(game: _):
            fatalError("Invalid state")
        case .math(let model):
            return model.progress
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
        guard case .math(let model) = type else {
            fatalError("Invalid state")
        }
        return NetworkService()
            .getQuestions(range: model.levelType.range, numberOfOptions: 4, numberOfQuestions: AppConfig().numberOfQuestions , oprator: model.oprator, noOfOprands: model.noOfOprands)
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
