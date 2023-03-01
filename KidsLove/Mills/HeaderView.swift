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
    internal init(id: UUID = UUID(), playerCoins: [CoinModel], playerMills: [CoinModel], name: String) {
        self.id = id
        self.playerCoins = playerCoins
        self.playerMills = playerMills
        self.name = name
    }
    
    var id: UUID = UUID()
    @Published var name: String
    @Published var playerCoins: [CoinModel]
    @Published var playerMills: [CoinModel]
}

func defaultPlayerCoins(imageName: String, range: ClosedRange<Int> = (0...9)) -> [CoinModel] {
    return range.map {num in CoinModel(imageName: imageName, offset: CGFloat(num*10))}
}

class HeaderViewModel: Identifiable, ObservableObject {
    internal init(id: UUID = UUID(), playerIcon: CoinModel) {
        self.id = id
        self.player1 = PlayerModel(playerCoins: defaultPlayerCoins(imageName: "coin1"), playerMills: [], name: "Silver Player")
        self.player2 = PlayerModel(playerCoins: defaultPlayerCoins(imageName: "coin2"), playerMills: [], name: "Gold Player")
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
    @State private var isMute = SoundPlayer.isMute

    var restratAction: ()-> Void
    var muteAction: ()-> Void

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(alignment: .top) {
                   SmallActionButton(title: "Restart", action: restratAction, enabled: true)
                    SmallActionButton(title: !isMute ? "Mute" : "Unmute", action: {
                        isMute.toggle()
                        muteAction()
                    }, enabled: true)
                }
                .padding()

                HStack(alignment: .top) {
                    PlayerScoreView(playerModel: model.player1)
                        .frame(width: geo.size.width*0.28)
                    ImageView(icon: model.playerIcon)
                        .frame(width: geo.size.width*0.28)
                    
                    PlayerScoreView(playerModel: model.player2)
                        .frame(width: geo.size.width*0.29)
                }
                .padding()
                .border(Color(UIColor.defaultThemeColor), width: 5)
                .cornerRadius(10)
            }

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
                .scaleEffect(x: (scaling ?  1 : 0), y: (scaling ?  1 : 0))
                .onAppear {
                    withAnimation(
                        .spring()
                        .repeatForever(
                            autoreverses: true)
                        .speed(0.25)) {
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
                Text(playerModel.name)
                    .font(.body.bold())
                if !playerModel.playerCoins.isEmpty {
                    Text("Coins")
                        .font(.body)
                    CoinView(coins:playerModel.playerCoins)
                }
                if !playerModel.playerMills.isEmpty {
                    Text("Mills")
                        .font(.body)
                    CoinView(coins: playerModel.playerMills)
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

