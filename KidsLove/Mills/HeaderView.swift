//
//  HeaderView.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 24/02/23.
//

import SwiftUI

class CoinModel: Identifiable, ObservableObject {
    internal init(id: UUID = UUID(), imageName: String, offset: CGFloat) {
        self.id = id
        self.imageName = imageName
        self.offset = offset
    }
    
    var offset: CGFloat
    
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
    return range.map {num in CoinModel(imageName: imageName, offset: CGFloat(num*10))}
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
            CoinModel(imageName: "coin2", offset: 5),
            CoinModel(imageName: "coin2", offset: 5),
            CoinModel(imageName: "coin2", offset: 5),
            CoinModel(imageName: "coin2", offset: 5),
            CoinModel(imageName: "coin2", offset: 5),
            CoinModel(imageName: "coin2", offset: 5),
            CoinModel(imageName: "coin2", offset: 5),
            CoinModel(imageName: "coin2", offset: 5),
            CoinModel(imageName: "coin2", offset: 5),
            CoinModel(imageName: "coin2", offset: 5)
        ]
    }
}



struct HeaderView: View {
    @ObservedObject var model: HeaderViewModel
    @State var size: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .top) {
                PlayerScoreView(playerModel: model.player1)
                    .frame(width: geo.size.width*0.33, height: geo.size.width*0.33)

                    .padding()
                ImageView(icon: model.playerIcon)
                    .frame(width: geo.size.width*0.33, height: geo.size.width*0.33)

                PlayerScoreView(playerModel: model.player2)
                    .frame(width: geo.size.width*0.33, height: geo.size.width*0.33)
                    .padding()
            }
            .border(Color(UIColor.defaultThemeColor), width: 5)
            .cornerRadius(10)
        }
    }
}

struct ImageView: View {
    @ObservedObject var icon: CoinModel
    @State private var scaling = false

    var body: some View {
        GeometryReader { geo in
            Image(icon.imageName)
                .resizable()
                .clipped()
                .scaledToFit()
                .frame(width: geo.size.width * 0.40)
                .cornerRadius(45/2)
                .padding()
                .offset(y: scaling ? 0 : 100)
                .onAppear {
                    withAnimation(
                        .spring()
                        .repeatForever(
                            autoreverses: false)) {
                                scaling.toggle()
                            }
                }
        }
    }
}

struct PlayerScoreView: View {
    @ObservedObject var playerModel: PlayerModel
    
    var body: some View {
        GeometryReader { geo in
            
            VStack(alignment: .leading) {
                Text("Player 1")
                    .font(.title)
                
                if !playerModel.playerCoins.isEmpty {
                    Text("Coins")
                        .font(.body)
                    CoinView(coins:playerModel.playerCoins)
//                        .frame(width: geo.size.width, height: geo.size.width*0.20)
//                        .background(.blue)
                    
                }
                
                if !playerModel.playerMills.isEmpty {
                    Text("Mills")
                        .font(.body)
                    CoinView(coins: playerModel.playerMills)
                        .frame(width: geo.size.width, height:  geo.size.width*0.30)

                }
            }
        }
    }
}

struct CoinView: View {
    var coins: [CoinModel]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(coins) { coin in
                    Image(coin.imageName)
                        .resizable()
                        .frame(width: geo.size.width*0.20, height:  geo.size.width*0.20)
                        .offset(x: coin.offset)
                }
            }
        }
    }
}

