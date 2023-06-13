import SwiftUI

struct SignUpView: View {
    @ObservedObject private var viewModel: SignUpViewModel
    @State var pushActive = false
    
    init(state: AppState) {
        self.viewModel = SignUpViewModel(authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink(destination: MainView(state: viewModel.state),
                               isActive: self.$pushActive) {
                    EmptyView()
                }.hidden()
                VStack(alignment: .leading, spacing: 30) {
                    Spacer()
                    Text("SignUpTitle")
                        .modifier(TextModifier(font: UIConfiguration.titleFont,
                                               color: UIConfiguration.tintColor))
                        .padding(.leading, 25)
                    VStack(alignment: .center, spacing: 30) {
                        VStack(alignment: .center, spacing: 25) {
                            CustomTextField(placeHolderText: NSLocalizedString("SignUpEmailPlaceholder", comment: ""),
                                            text: $viewModel.email)
                            CustomTextField(placeHolderText: NSLocalizedString("SignUpPasswordPlaceholder", comment: ""),
                                            text: $viewModel.password,
                                            isPasswordType: true)
                        }.padding(.horizontal, 25)
                        
                        VStack(alignment: .center, spacing: 40) {
                            customButton(title: NSLocalizedString("SignUpButton", comment: ""),
                                         backgroundColor: UIConfiguration.tintColor,
                                         action: self.viewModel.signUp)
                        }
                    }
                }
                Spacer()
            }.alert(item: self.$viewModel.statusViewModel) { status in
                Alert(title: Text(status.title),
                      message: Text(status.message),
                      dismissButton: .default(Text(NSLocalizedString("SignUpDialogAccept", comment: "")), action: { self.pushActive = true }))
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(state: AppState())
    }
}
