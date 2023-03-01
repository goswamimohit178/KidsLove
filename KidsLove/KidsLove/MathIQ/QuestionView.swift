//
//  ContentView.swift
//  Question
//
//  Created by Vikash on 27/02/23.
//

import SwiftUI

struct QuestionView: View {
    @State var questionViewModel: QuestionViewModel
    private var optionButtonHeight: CGFloat {
        return UIScreen.screenWidth*0.15
    }
    let transform = CGAffineTransformMakeScale(1.0, 6.0)
    var body: some View {
        VStack {
            ProgressView(value: 0.3)
                .transformEffect(transform)
            RopeView()
            BlackBoardView(questionText: questionViewModel.questionText)
            Spacer()
            OptionView(model: $questionViewModel)
            Spacer()
            CheckContinueButtonView(model: questionViewModel, title: "Check")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let mathModel = MathModel(progress: .complete, oprator: .addition, noOfOprands: 4, levelType: .easy)
        let levelCellModel = LevelCellModel(type: .math(mathModel: mathModel ), title: "hello")
        let questionViewModel = QuestionViewModel(model: levelCellModel)
                                                        
        QuestionView(questionViewModel: questionViewModel)
    }
}



struct RopeView: View {
    private var width: CGFloat {
        return UIScreen.screenWidth*0.25
    }
    private var height: CGFloat {
        return UIScreen.screenHeight*0.09
    }
    var body: some View {
        HStack{
            Spacer()
            Image("rope")
                .resizable()
                .frame(width: width,height: height)
            Spacer()
            Image("rope")
                .resizable()
                .frame(width: width,height: height)
            Spacer()
        }.offset(y: 10)
    }
}

struct BlackBoardView: View {
    private var width: CGFloat {
        return UIScreen.screenWidth*0.9
    }
    private var blackBoardheight: CGFloat {
        return UIScreen.screenHeight*0.25
    }
    var questionText: String
    var body: some View {
        ZStack{
            Image("light-wooden-background")
                .resizable()
                .frame(width: width,height: blackBoardheight,alignment: .top)
                .cornerRadius(20)
            Rectangle()
                .cornerRadius(20)
                .frame(width: width*0.9, height: blackBoardheight*0.8)
            Text("\(questionText)")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}
struct CheckContinueButtonView: View{
    let model: QuestionViewModel
    var title: String
    private var width: CGFloat {
        return UIScreen.screenWidth*0.9
    }
    private var height: CGFloat {
        return UIScreen.screenWidth*0.15
    }
    var body: some View {
        Button("\(title)") {
            model.checkButtonTapped()
        }
        .foregroundColor(.white)
        .frame(width: width,height: height)
        .background(.red)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct OptionButtonsView: View {
    var title: String
    var optionNumber: Int
    @Binding var model: QuestionViewModel
    private var width: CGFloat {
        return UIScreen.screenWidth*0.8
    }
    private var optionButtonHeight: CGFloat {
        return UIScreen.screenWidth*0.15
    }
    var body: some View {
        Button("\(title)") {
            self.model.optionButtonTapped(optionNumber: optionNumber)
        }
        .foregroundColor(.white)
        .frame(width: width,height: optionButtonHeight)
        .background(model.buttonBackgroundColor)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct OptionView: View {
    @Binding var model: QuestionViewModel
    var body: some View {
        let answerArray = model.answer
        VStack{
            Spacer()
            OptionButtonsView(title: "\(answerArray[0])", optionNumber: 0, model: $model)
            Spacer(minLength: 10)
            OptionButtonsView(title: "\(answerArray[1])", optionNumber: 1, model: $model)
            Spacer(minLength: 10)
            OptionButtonsView(title: "\(answerArray[2])", optionNumber: 2, model: $model)
            Spacer(minLength: 10)
            OptionButtonsView(title: "\(answerArray[3])", optionNumber: 3, model: $model)
            Spacer()
        }
    }
}
