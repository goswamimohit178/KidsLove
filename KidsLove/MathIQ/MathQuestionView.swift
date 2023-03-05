//
//  MathQuestionView.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 20/02/23.
//

import SwiftUI

struct MathQuestionView: View {
    var body: some View {
        ZStack {
            Color.black
            Text("2 + 2 = 4")
                .font(.custom("White Milk", size: 50))
                .foregroundColor(.white)
        }
    }
}

struct MathQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        MathQuestionView()
    }
}
