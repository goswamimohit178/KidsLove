import SwiftUI

struct ActionButton: View {
    let title: String
    let action: () -> ()
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .padding(12)
                .background(Color.boardBackground)
                .cornerRadius(6)
            
        }
        
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(title: "NEW GAME") { }
    }
}
extension ActionButton {
    private var confirmationAlert: Alert {
        Alert(title: confirmationMessage,
              primaryButton: resetScoreAlertButton,
              secondaryButton: .cancel())
    }
    
    private var confirmationMessage: Text {
        Text("Are you sure you want to erase your best score?")
    }
    
    private var resetScoreAlertButton: Alert.Button {
        .default(Text("Yeah, whatever"), action: self.action)
    }
}
