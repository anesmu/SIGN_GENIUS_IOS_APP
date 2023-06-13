import SwiftUI

struct MainView: UIViewControllerRepresentable {
    @ObservedObject var state: AppState
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "MainViewController", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "MainViewController") as! MainViewController
        controller.logoutAction = {
            self.state.logout()
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(state: AppState())
    }
}
