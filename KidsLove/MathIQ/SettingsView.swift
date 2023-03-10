//
//  SwiftUIView.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 17/02/23.
//

import SwiftUI
import GameKit

struct SettingsView: View {
    @State private var selectedTheme = ThemeManager.theme
    @State private var isMute = SoundPlayer.isMute
    @State private var selectedThemeColor = Color(ThemeManager.themeColor)
    @State var showView = false
    private var themeUpdated: (() -> Void)
    let themes = ["default", "light", "dark"]
    
    init(themeUpdated: @escaping () -> Void) {
        self.themeUpdated = themeUpdated
    }
    
    var body: some View {
        NavigationView {
            List {

                //                Section(header: Text("ACCOUNT")) {
                //                    NavigationLink(destination: AccountView()) {
                //                        Label("Account", systemImage: "person")
                //                    }
                //                    NavigationLink(destination: SecurityView()) {
                //                        Label("Security", systemImage: "lock")
                //                    }
                //                }

//                Section(header: Text("Debug")) {
//                    NavigationLink(destination: NewQuestionsView()) {
//                        Label("Add questions", systemImage: "person")
//                    }
//                }

                
                Section(header: Text("OTHER PREFERENCES")) {
                    Picker(selection: $selectedTheme, label: Text("Theme")) {
                        ForEach(themes, id: \.self) { theme in
                            Text(theme.capitalized)
                        }
                    }
                    .onChange(of: selectedTheme) { theme in
                        updateTheme(theme)
                    }
                    
                    ColorPicker("Theme color", selection:  $selectedThemeColor)
                    Toggle("Mute", isOn: $isMute)
                        .onChange(of: isMute) { value in
                            SoundPlayer.isMute = value
                        }
                    Picker("Language", selection: .constant(0)) {
                        Text("English").tag(0)
                        //                        Text("Spanish").tag(1)
                        //                        Text("Chinese").tag(2)
                    }
                    .onChange(of: selectedThemeColor) { color in
                        updateThemeColor(color)
                    }
                    .listStyle(GroupedListStyle())
                    .navigationTitle("Settings")
                }
                
                Section(header: Text("LEADER BOARD")) {
                    Button {
                        showView.toggle()
                    } label: {
                        Text("Achievements")
                    }
                    .sheet(isPresented: $showView) {
                        MyView(isAchievement: true) {
                            showView.toggle()
                        }
                    }
                    Button {
                        showView.toggle()
                    } label: {
                        Text("leaderBoard")
                    }
                    .sheet(isPresented: $showView) {
                        MyView(isAchievement: false, gameCenterViewControllerDidFinish: {
                            showView.toggle()
                        })
                    }
                }
            }
        }
    }
    
    private func updateTheme(_ theme: String) {
        ThemeManager.theme = theme
        var themeStyle: UIUserInterfaceStyle = .unspecified
        switch theme {
        case "dark":
            themeStyle = .dark
        case "light":
            themeStyle = .light
        default:
            break
        }
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as?UIWindowScene)?.windows ?? [] }
            .forEach { $0.overrideUserInterfaceStyle = themeStyle }
    }
    
    private func updateThemeColor(_ color: Color) {
        UINavigationBar.appearance().tintColor = UIColor(color)
        ThemeManager.themeColor = UIColor(color)
        UIColor.defaultThemeColor = UIColor(color)
        themeUpdated()
    }
}

struct AccountView: View {
    var body: some View {
        Text("Account Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(themeUpdated: {})
    }
}

struct MyView: UIViewControllerRepresentable {
    let isAchievement: Bool = false
    let gameCenterControllerDelegate: GameCenterControllerDelegate
    typealias UIViewControllerType = GKGameCenterViewController
    init(isAchievement: Bool ,gameCenterViewControllerDidFinish: @escaping () -> (Void)) {
        self.gameCenterControllerDelegate = GameCenterControllerDelegate() {
            gameCenterViewControllerDidFinish()
        }
    }
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        // Return MyViewController instance
        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = gameCenterControllerDelegate
        if isAchievement == true{
            vc.viewState = .achievements
        } else {
            vc.viewState = .leaderboards
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
class GameCenterControllerDelegate: NSObject, GKGameCenterControllerDelegate {
    internal init(gameCenterViewControllerDidFinish: @escaping () -> (Void)) {
        self.gameCenterViewControllerDidFinish = gameCenterViewControllerDidFinish
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewControllerDidFinish()
    }
    var gameCenterViewControllerDidFinish: () -> (Void)
}
