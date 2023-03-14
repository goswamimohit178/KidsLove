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
    @State var sections: [SectionModel]
    
    init(sections: [SectionModel]) {
        self.sections = sections
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                List(sections) { section in
                    Section(section.sectionTittle) {
                        ForEach(section.items) { item in
                            Button(item.btnTittle ) {
                                item.action()
                            }
                        }
                        .modifier(DefaultButtonMills(width:  geo.size.width * 0.70))
                    }
                }
                
            }
            .frame(height: geo.size.height * 0.90)
            .padding(40)
            .cornerRadius(150)
        }
    }
}

    struct MillsLaunchUIView_Previews: PreviewProvider {
        static var previews: some View {
            MillsLaunchUIView(sections: [SectionModel]())
        }
    }


    
    enum PlayWith {
        case withPlayerOnline(OnlinePlayerModel)
        case withPlayerOffline
        case withComputer(level: ComputerLevel)
    }
    
    enum ComputerLevel {
        case easyLevel
        case mediumLevel
        case HardLevel
    }
    struct DefaultButtonMills: ViewModifier {
        private var buttonWidth: CGFloat
        
        init(width: CGFloat) {
            self.buttonWidth = width
        }
        
        func body(content: Content) -> some View {
            content
                .frame(width: buttonWidth,
                       height: 50)
                .background(Color(ThemeManager.themeColor))
                .cornerRadius(30)
                .padding(.all)
                .foregroundColor(Color(UIColor.systemBackground))
                //.shadow(radius: 20)
            
        }
    }
