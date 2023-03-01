//
//  HeaderView.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 24/02/23.
//

import SwiftUI

class CoinModel: Identifiable, ObservableObject {
    internal init(id: UUID = UUID(), imageName: String) {
        self.id = id
        self.imageName = imageName
    }
    
    var id: UUID = UUID()
    @Published var imageName: String
}

class PlayerModel: Identifiable, ObservableObject {
    internal init(id: UUID = UUID(), playerCoins: [CoinModel], playerMills: [CoinModel]) {
        self.id = id
        self.playerCoins = playerCoins
        self.playerMills = playerMills
    }
    
    var id: UUID = UUID()
    @Published var playerCoins: [CoinModel]
    @Published var playerMills: [CoinModel]
}

func defaultPlayerCoins(imageName: String, range: ClosedRange<Int> = (0...9)) -> [CoinModel] {
    return range.map {_ in CoinModel(imageName: imageName)}
}

class HeaderViewModel: Identifiable, ObservableObject {
    internal init(id: UUID = UUID(), playerIcon: CoinModel) {
        self.id = id
        self.player1 = PlayerModel(playerCoins: defaultPlayerCoins(imageName: "coin1"), playerMills: [])
        self.player2 = PlayerModel(playerCoins: defaultPlayerCoins(imageName: "coin2"), playerMills: [])
        self.playerIcon = playerIcon
    }
    var id: UUID = UUID()
    @Published var player1: PlayerModel
    @Published var player2: PlayerModel
    @Published var playerIcon: CoinModel
    
    static var testData: [CoinModel] {
        return [
            CoinModel(imageName: "coin2"),
            CoinModel(imageName: "coin2"),
            CoinModel(imageName: "coin2"),
            CoinModel(imageName: "coin2"),
            CoinModel(imageName: "coin2"),
            CoinModel(imageName: "coin2"),
            CoinModel(imageName: "coin2"),
            CoinModel(imageName: "coin2"),
            CoinModel(imageName: "coin2"),
            CoinModel(imageName: "coin2")
        ]
    }
}



struct HeaderView: View {
    @ObservedObject var model: HeaderViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            PlayerScoreView(playerModel: model.player1)
                .padding()
            ImageView(icon: model.playerIcon)
                .padding()
            
            PlayerScoreView(playerModel: model.player2)
                .padding()
        }
        .border(Color(UIColor.defaultThemeColor), width: 5)
        //        .shadow(radius: 10)
        .cornerRadius(10)
    }
}

//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderView(model: HeaderViewModel.testModel)
//    }
//}

struct ImageView: View {
    @ObservedObject var icon: CoinModel
    
    var body: some View {
        Image(icon.imageName)
            .resizable()
            .frame(width: 45, height: 45)
            .cornerRadius(45/2)
        
    }
}

struct PlayerScoreView: View {
    @ObservedObject var playerModel: PlayerModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Player 1")
                .font(.title)
            Text("Coins")
                .font(.body)
            //            if !playerModel.playerCoins.isEmpty {
            CoinView(coins:playerModel.playerCoins)
            //            }
            Text("Mills")
                .font(.body)
            //            if !playerModel.playerMills.isEmpty {
            CoinView(coins: playerModel.playerMills)
            //            }
        }
    }
}

struct CoinView: View {
    var coins: [CoinModel]
    
    var gridItemLayout = [
        GridItem(.adaptive(minimum: 10), spacing: 5),
        GridItem(.adaptive(minimum: 10), spacing: 5),
        GridItem(.adaptive(minimum: 10), spacing: 5)
    ]
    
    var body: some View {
        LazyVGrid(columns: gridItemLayout, spacing: 0) {
            ForEach(coins) { coin in
                Image(coin.imageName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(2)
                    .cornerRadius(45/2)
            }
        }
        .padding(6)
        .cornerRadius(5)
        .border(Color(UIColor.defaultThemeColor), width: 3)
        .listRowInsets(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
    }
    
    
}
