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
        return UIScreen.screenWidth*0.90
    }
    
    @State var showingAlert = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
               
                ScoreBox(title: "Moves", score: moves)
                    .frame(width: size/3)
//                    .frame(maxWidth: .infinity)

                   .aspectRatio(contentMode: .fill)
                ScoreBox(title: scoreLabel, score:score)
                    .frame(width: size/3)
//                    .frame(maxWidth: .infinity)

                    .aspectRatio(contentMode: .fill)
                ScoreBox(title: bestScoreLabel, score: bestScore)
                    .frame(width: size/3)
//                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: size)

            
          HStack(alignment: .top) {
                SmallActionButton(title: "NEW GAME", action: self.menuAction, enabled: true)
                  .frame(maxWidth: .infinity)
            
              SmallActionButton(title: "UNDO", action: self.undoAction, enabled: undoEnabled)
                  .frame(maxWidth: .infinity)

          }
          .frame(width: size)
          .background(.red)

        }
        .frame(width: size)
//        .aspectRatio(contentMode: .fill)

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
