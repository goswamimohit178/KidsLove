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
    var roundingLevel: LevelCellModel
    var reviewLevel: LevelCellModel
}
struct LevelCellModel {
    let title: String
    var questions:[Question]
}
struct Question {
    let num1:Int
    let num2:Int
    let operation: String
    let answer: [Int]
    let correctAnswer: Int
}
