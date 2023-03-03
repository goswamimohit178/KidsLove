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
            
            Button("Make JSON") {
                makeJson(questions: questions)
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
   
    private func makeJson(questions: [Question]) { 
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!

        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("test.json")
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false

        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: (jsonFilePath?.absoluteString)!, isDirectory: &isDirectory) {
            let created = fileManager.createFile(atPath: jsonFilePath!.absoluteString, contents: nil, attributes: nil)
            if created {
                print("File created ")
            } else {
                print("Couldn't create file for some reason")
            }
        } else {
            print("File already exists")
        }

        // creating JSON out of the above array
        
        let encodedData = try! JSONEncoder().encode(questions)
        let jsonString = String(data: encodedData,
                                encoding: .utf8)
        
//        var jsonData: NSData!
//        do {
//            jsonData = try JSONSerialization.data(withJSONObject: questions, options: JSONSerialization.WritingOptions()) as NSData
//            let jsonString = String(data: jsonData as Data, encoding: String.Encoding.utf8)
//            print(jsonString as Any)
//        } catch let error as NSError {
//            print("Array to JSON conversion failed: \(error.localizedDescription)")
//        }

        // Write that JSON to the file created earlier
        //    let jsonFilePath = documentsDirectoryPath.appendingPathComponent("test.json")
        do {
            let fileURL = URL(fileURLWithPath: jsonFilePath!.absoluteString)

            try jsonString?.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            print("JSON data was written to teh file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewQuestionsView(currentQuestion: emptyQuestion)
    }
}


var emptyQuestion: Question = Question(questionText: "", answer: ["","","",""], correctAnswer: "")
