import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @State var showMenu = false
    @State private var showingAlert = false
    
    var body: some View {
        VStack(alignment: .center) {
            Header(score: viewModel.state.score, bestScore: viewModel.bestScore, menuAction: {
                showingAlert = true
            }, undoAction: {
                self.viewModel.undo()
            }, undoEnabled: self.viewModel.isUndoable, moves: viewModel.numberOfMoves)
            
//            GoalText()
            Board(board: viewModel.state.board, addedTile: viewModel.addedTile)
            Moves(viewModel.numberOfMoves)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Please confirm"),message: Text("Are you sure to start a new game?"), primaryButton: .cancel() {
                self.viewModel.reset()
            }, secondaryButton: .destructive(Text("cancellll")))
        }
        .frame(minWidth: .zero,
               maxWidth: .infinity,
               minHeight: .zero,
               maxHeight: .infinity,
               alignment: .center)
            .background(Color.gameBackground)
            .background(Menu())
            .background(GameOver())
            .edgesIgnoringSafeArea(.all)
            
    }
}

extension GameView {
    private func Menu() -> some View {
        EmptyView().sheet(isPresented: $showMenu) {
            MenuView(newGameAction: {
                self.viewModel.reset()
                self.showMenu.toggle()
            }, resetScoreAction: {
                self.viewModel.eraseBestScore()
                self.showMenu.toggle()
            })
        }
    }
    
    private func GameOver() -> some View {
        EmptyView().sheet(isPresented: $viewModel.isGameOver) {
            GameOverView(score: self.viewModel.state.score, moves: self.viewModel.numberOfMoves) {
                self.viewModel.reset()
            }
        }
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let engine = GameEngine()
        let storage = LocalStorage()
        let stateTracker = GameStateTracker(initialState: (storage.board ?? engine.blankBoard, storage.score))
        return GameView(viewModel: GameViewModel(engine, storage: storage, stateTracker: stateTracker))
    }
}
