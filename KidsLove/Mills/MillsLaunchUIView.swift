//
//  MillsLaunchUIView.swift
//  KidsLove
//
//  Created by Babblu Bhaiya on 10/03/23.
//

import SwiftUI
struct MillsLaunchUIView: View {
    @State private var tappedBtn = false
    @State private var tappedBtn1 = false
    @State private var tappedBtn2 = false
    @State private var tappedBtn3 = false
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button("Play with Player") {
                        tappedBtn.toggle()
                    }
                    .sheet(isPresented: $tappedBtn) {
                        MyPresentableView(playWith: .withPlayerOffline)
                    }
                }
                Section("Play With Computer"){
                    
                    Button("Easy"){
                        tappedBtn1.toggle()
                    } .sheet(isPresented: $tappedBtn1) {
                        MyPresentableView(playWith: .withComputer(level: .easyLevel))
                    }
                    
                    Button("Medium"){
                        tappedBtn2.toggle()
                    } .sheet(isPresented: $tappedBtn2) {
                        MyPresentableView(playWith: .withComputer(level: .mediumLevel))
                    }
                    Button("Hard"){
                        tappedBtn3.toggle()
                    }
                    .sheet(isPresented: $tappedBtn3) {
                        MyPresentableView(playWith: .withComputer(level: .HardLevel))
                    }
                    
                }
            }
        }
    }
}
struct MillsLaunchUIView_Previews: PreviewProvider {
    static var previews: some View {
        MillsLaunchUIView()
    }
}



enum PlayWith {
    case withPlayerOffline
    case withComputer(level: ComputerLevel)
}

enum ComputerLevel {
    case easyLevel
    case mediumLevel
    case HardLevel
}

struct MyPresentableView: UIViewControllerRepresentable {
    let playWith: PlayWith!
    func makeUIViewController(context: Context) -> GameVC {
        let vc  =  GameVC()
        vc.name = playWith
        return vc
    }
    
    func updateUIViewController(_ uiViewController: GameVC, context: Context) {
        
    }
    
//    typealias UIViewControllerType = GameVC
    
}
