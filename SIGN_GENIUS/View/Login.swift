import SwiftUI
import Combine
import FirebaseAuth

struct Login: View {
    @State var pushActive = false
    @ObservedObject private var viewModel: SignInViewModel
    
    init(state: AppState) {
        self.viewModel = SignInViewModel(authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        
        VStack {
            NavigationLink(destination: MainView(state: viewModel.state),
                           isActive: self.$pushActive) {
                EmptyView()
            }.hidden()
            VStack(alignment: .leading, spacing: 10) {
                Spacer().frame(maxHeight: 30)
                Text("LoginTitle")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                    .padding(.leading, 25)
                    .padding(.bottom, 80)
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {
                        CustomTextField(placeHolderText: NSLocalizedString("LoginEmailPlaceholder", comment: ""),
                                        text: $viewModel.email)
                        CustomTextField(placeHolderText: NSLocalizedString("LoginPasswordPlaceholder", comment: ""),
                                        text: $viewModel.password,
                                        isPasswordType: true)
                    }.padding(.horizontal, 25)
                    
                    VStack(alignment: .center, spacing: 40) {
                        customButton(title: NSLocalizedString("LoginUpButton", comment: ""),
                                     backgroundColor: UIConfiguration.tintColor,
                                     action: { self.viewModel.login() })
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
                  dismissButton: .default(Text(NSLocalizedString("LoginDialogAccept", comment: "")), action: {
                if status.title == "Successful" {
                    self.pushActive = true
                }
            }))
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(state: AppState())
    }
}
