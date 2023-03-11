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
            GeometryReader { geo in
                List {
                    Section("Play with Friend") {
                        Button("Play") {
                            tappedBtn.toggle()
                        }
                        .modifier(DefaultButtonMills(width:  geo.size.width))
                      
                    }
                    
                    Section("Play With Computer"){
                        Button("Easy"){
                            tappedBtn1.toggle()
                        }
                        .modifier(DefaultButtonMills(width:  geo.size.width))
                        Button("Medium"){
                            tappedBtn2.toggle()
                        }
                        .modifier(DefaultButtonMills(width:  geo.size.width))
                        Button("Hard"){
                            tappedBtn3.toggle()
                        }
                        .modifier(DefaultButtonMills(width:  geo.size.width))
                    }
                }
            }
        }
        NavigationLink(destination: MyPresentableView(playWith: .withPlayerOffline), isActive: $tappedBtn) { }
        NavigationLink(destination: MyPresentableView(playWith:  .withComputer(level: .easyLevel)), isActive: $tappedBtn1) {  }
        NavigationLink(destination: MyPresentableView(playWith: .withComputer(level: .mediumLevel)), isActive: $tappedBtn2) {  }
        NavigationLink(destination: MyPresentableView(playWith: .withComputer(level: .HardLevel)), isActive: $tappedBtn3) {  }
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
        vc.gameMode = playWith
        return vc
    }
    
    func updateUIViewController(_ uiViewController: GameVC, context: Context) {
        
    }
}

struct DefaultButtonMills: ViewModifier {
    private var buttonWidth: CGFloat
    
    init(width: CGFloat) {
        self.buttonWidth = min(width * 1.0, 350.0)
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: buttonWidth,
                   height: 50,
                   alignment: .center)
            .background(Color(ThemeManager.themeColor))
            .cornerRadius(40)
            .padding(.all, 7)
            .foregroundColor(Color(UIColor.systemBackground))
            .shadow(radius: 20)
        
    }
}
