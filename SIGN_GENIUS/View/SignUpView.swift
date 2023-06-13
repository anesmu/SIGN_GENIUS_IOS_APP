import SwiftUI

struct SignUpView: View {
    @ObservedObject private var viewModel: SignUpViewModel
    @State var pushActive = false
    
    init(state: AppState) {
        self.viewModel = SignUpViewModel(authAPI: AuthService.shared, state: state)
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
                    Text("Sign Up")
                        .modifier(TextModifier(font: UIConfiguration.titleFont,
                                               color: UIConfiguration.tintColor))
                        .padding(.leading, 25)
                    VStack(alignment: .center, spacing: 30) {
                        VStack(alignment: .center, spacing: 25) {
                            CustomTextField(placeHolderText: "Full Name",
                                            text: $viewModel.fullName)
                            CustomTextField(placeHolderText: "Phone Number",
                                            text: $viewModel.phoneNumber)
                            CustomTextField(placeHolderText: "E-mail Address",
                                            text: $viewModel.email)
                            CustomTextField(placeHolderText: "Password",
                                            text: $viewModel.password,
                                            isPasswordType: true)
                        }.padding(.horizontal, 25)
                        
                        VStack(alignment: .center, spacing: 40) {
                            customButton(title: "Create Account",
                                         backgroundColor: UIColor(hexString: "#334D92"),
                                         action: self.viewModel.signUp)
                        }
                    }
                }
                Spacer()
            }.alert(item: self.$viewModel.statusViewModel) { status in
                Alert(title: Text(status.title),
                      message: Text(status.message),
                      dismissButton: .default(Text("OK"), action: { self.pushActive = true }))
            }
        }
    }
    
    private func customButton(title: String,
                              backgroundColor: UIColor,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .modifier(ButtonModifier(font: UIConfiguration.buttonFont,
                                         color: backgroundColor,
                                         textColor: .white,
                                         width: 275,
                                         height: 45))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(state: AppState())
    }
}
