import SwiftUI

struct Moves: View {
    let moves: Int
    
    init(_ moves: Int) {
        self.moves = moves
    }
    
    var body: some View {
        HStack {
//            Text("moves: \(moves)").bold()
        }
        .font(.myBodyFont)
        .foregroundColor(.white50)
    }
}
struct Moves_Previews: PreviewProvider {
    static var previews: some View {
        Moves(123)
    }
}
