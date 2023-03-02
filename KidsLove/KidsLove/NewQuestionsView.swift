//
//  ContentView.swift
//  MakeQuestion
//
//  Created by Babblu Bhaiya on 01/03/23.
//

import SwiftUI

struct NewQuestionsView: View {
    @State var currentQuestion: Question = emptyQuestion
    @State var questions: [Question] = []
    
    var body: some View {
        VStack {
            TextField("Enter Question ", text: $currentQuestion.questionText)
            TextField("Options", text: $currentQuestion.answer[0])
            TextField("Options", text: $currentQuestion.answer[1])
            TextField("Options", text: $currentQuestion.answer[2])
            TextField("Options", text: $currentQuestion.answer[3])
            TextField("Answer is ", text: $currentQuestion.correctAnswer)
            Button("Make Question") {
                questions.append(currentQuestion)
                currentQuestion = emptyQuestion
            }
            NavigationView {
                List() {
                    ForEach(questions) { question in
                        let options = question.answer.map { $0 + "," }.reduce("", +)
                        Button("\(question.questionText), \(options), \(question.correctAnswer)", role: .cancel) {
                            currentQuestion = question
                        }
                    }
                    .onDelete(perform: onDelete)
                    .onMove(perform: onMove)
                }
            }
        }
    }
    func subcategoryView(items: [String], rightAnswer: String) -> some View {
        Group {
            Text("Answer is:: \(rightAnswer)")
            List(items, id: \.self) { item in
                Text(item)
            }
        }
    }
    private func onDelete(offsets: IndexSet) {
        questions.remove(atOffsets: offsets)
    }
    
    // 3.
    private func onMove(source: IndexSet, destination: Int) {
        questions.move(fromOffsets: source, toOffset: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewQuestionsView(currentQuestion: emptyQuestion)
    }
}


var emptyQuestion: Question = Question(questionText: "", answer: ["","","",""], correctAnswer: "")
