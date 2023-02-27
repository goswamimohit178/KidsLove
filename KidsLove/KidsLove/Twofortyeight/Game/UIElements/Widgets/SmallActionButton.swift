import SwiftUI


struct SmallActionButton: View {
    let title: String
    let action: () -> ()
    var enabled: Bool
    @State var showingAlert: Bool = false
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .font(.system(size: 19, weight: .black, design: .rounded))
              .padding(.horizontal, 20)
                .padding(.vertical, 9)
                .background(enabled ? Color.boardBackground : Color(UIColor.disableButtonColor()))
                .foregroundColor(enabled ? Color.white : Color(UIColor.white.withAlphaComponent(0.5)))
                .cornerRadius(4)
                
            }
        .disabled(!enabled)
    }
}

struct SmallActionButton_Previews: PreviewProvider {
    static var previews: some View {
        SmallActionButton(title: "MENU", action: {}, enabled: false)
    }
}
