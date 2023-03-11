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
    @State var buttonModel = [SectionModel( item: [ButtonType(btnTittle: "Play With Friend", action: { print("Play btn Tapped")})], sectionTittle: "Play with player"),
                              SectionModel(item: [ButtonType(btnTittle: "Easy Level", action: {print("Easy Level")})], sectionTittle: "Play with Computer")
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                List(buttonModel) { buttons in
                    Section(buttons.sectionTittle) {
                        Button("Play") {
                            tappedBtn.toggle()
                        }
                        .modifier(DefaultButtonMills(width:  geo.size.width))
                    }
                    Section(buttons.sectionTittle){
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
            // NavigationLink(destination: ContentView(), isActive: $tappedBtn3) {  }
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

/////////////////////////////////////////////////Make Buttons/////////////////
///
//struct CustomButton: View {
//var title: String
//var action: () -> Void
//var color: Color
//
//var body: some View {
//    GeometryReader { geo in
//        Button(btnTittle: action) {
//            Text(title)
//                .foregroundColor(.white)
//                .font(.headline)
//        }
//        .modifier(DefaultButtonMills(width:  geo.size.width))
//    }
//
//}
//}
//struct ContentView: View {
//    let buttons = [
//        CustomButton(title: "Button 1", action: { print("Button 1 tapped") }, color: .blue),
//        CustomButton(title: "Button 2", action: { print("Button 2 tapped") }, color: .red),
//        CustomButton(title: "Button 3", action: { print("Button 3 tapped") }, color: .green)
//    ]
//
//    var body: some View {
//        VStack {
//            ForEach(buttons, id: \.title) { button in
//                button
//            }
//        }
//        .padding()
//
//    }
//}
