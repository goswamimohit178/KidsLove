import SwiftUI

struct Header: View {
    let score: Int
    let bestScore: Int
    let scoreLabel = "SCORE"
    let bestScoreLabel = "BEST"
    let menuAction: () -> Void
    let undoAction: () -> Void
    var undoEnabled: Bool
    var moves: Int
    private var size: CGFloat {
        return UIScreen.screenWidth*0.85
    }
    
    @State var showingAlert = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                SmallActionButton(title: "NEW GAME", action: self.menuAction, enabled: true)
                SmallActionButton(title: "UNDO", action: self.undoAction, enabled: undoEnabled)
            }
            
            HStack(alignment: .top) {
                ScoreBox(title: "Moves", score: moves)
                ScoreBox(title: "Score", score: score)
                ScoreBox(title: "Best Score", score: bestScore)
            }
        }
        .frame(width: size)
    }
}
struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(score: 10, bestScore: 12345, menuAction: {
            print("tapped on menu")
        }, undoAction: {
            print("tapped on undo")
        }, undoEnabled: false, moves: 10)
    }
}
