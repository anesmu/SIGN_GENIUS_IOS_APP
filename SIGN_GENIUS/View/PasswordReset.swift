import SwiftUI
import Combine
import FirebaseAuth

struct PasswordReset: View {
    @ObservedObject private var viewModel: PasswordResetViewModel
    
    init(state: AppState) {
        self.viewModel = PasswordResetViewModel (authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Spacer().frame(maxHeight: 30)
                Text("PasswordResetTitle")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                    .padding(.leading, 25)
                    .padding(.bottom, 80)
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {
                        CustomTextField(placeHolderText: NSLocalizedString("PasswordResetEmailPlaceholder", comment: ""),
                                        text: $viewModel.email)
                    }.padding(.horizontal, 25)
                    
                    VStack(alignment: .center, spacing: 40) {
                        customButton(title: NSLocalizedString("PasswordResetButton", comment: ""),
                                     backgroundColor: UIConfiguration.tintColor,
                                     action: { self.viewModel.passwordReset() })
                    }
                }
            }
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(item: self.$viewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text(NSLocalizedString("PasswordResetDialogAccept", comment: ""))))
        }
    }
}

struct PasswordReset_Previews: PreviewProvider {
    static var previews: some View {
        PasswordReset(state: AppState())
    }
}
