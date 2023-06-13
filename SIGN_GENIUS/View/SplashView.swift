import SwiftUI

struct SplashView: View {
    @State var isActive:Bool = false
    @ObservedObject var state: AppState
    
    var body: some View {
        VStack {
            if self.state.currentUser != nil {
                MainView(state: state)
            } else if self.isActive {
                WelcomeView(state: state)
            } else {
                ZStack {
                    Color(UIConfiguration.tintColor)
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        Image(systemName: "waveform.circle")
                            .resizable()
                            .frame(width: 120, height: 120, alignment: .center)
                            .foregroundColor(.yellow)
                        Text("SplashViewAppTitle")
                            .modifier(TextModifier(font: UIConfiguration.titleFont, color: UIConfiguration.subtitleColor))
                        
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        .onReceive(state.$didLogOut) { didLogOut in
            if didLogOut {
                self.isActive = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
                self.state.didLogOut = false
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView( state: AppState())
    }
}
