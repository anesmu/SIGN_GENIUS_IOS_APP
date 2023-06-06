import SwiftUI

struct WelcomeView: View {
    @State private var index = 1
    @State private var pushActive = false
    @ObservedObject var state: AppState
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: destinationView(),
                               isActive: self.$pushActive) {
                                EmptyView()
                }
                .navigationBarHidden(true)
                
                VStack(spacing: 40) {
                    Image(systemName: "waveform.circle")
                        .resizable()
                        .frame(width: 120, height: 120, alignment: .center)
                        //.colorMultiply(Color(UIConfiguration.tintColor))
                        .foregroundColor(.yellow)
                        .padding(.top, 100)
                    
                    Text("WelcomeViewTitle")
                        .modifier(TextModifier(font: UIConfiguration.titleFont,
                                               color: UIConfiguration.tintColor))
                    
                    Text("WelcomeViewDescription")
                        .modifier(TextModifier(font: UIConfiguration.subtitleFont))
                        .padding(.horizontal, 60)
                    
                    VStack(spacing: 25) {
                        Button(action: {
                            self.index = 1
                            self.pushActive = true
                        }) {
                            Text("WelcomeViewLogin")
                                .modifier(ButtonModifier(font: UIConfiguration.buttonFont,
                                                         color: UIConfiguration.tintColor,
                                                         textColor: .white,
                                                         width: 275,
                                                         height: 55))
                        }
                        Button(action: {
                            self.index = 2
                            self.pushActive = true
                        }) {
                            Text("WelcomeViewRegister")
                                .modifier(TextModifier(font: UIConfiguration.buttonFont,
                                                       color: .black))
                                .frame(width: 275, height: 55)
                                .overlay(RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    private func destinationView() -> AnyView {
        switch index {
        case 1:
            return AnyView(Login(state: state))
        default:
            return AnyView(SignUpView(state: state))
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(state: AppState())
    }
}
