import SwiftUI
import FirebaseAuth
import Combine

class AppState: ObservableObject {
    @Published var didLogOut: Bool = false
    @Published var currentUser: User?
    
    private var cancellable: AnyCancellable?
    private let authService = AuthService.shared
    
    init() {
       /* cancellable = authService.addListener()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] user in
                DispatchQueue.main.async {
                    self?.currentUser = user
                }
            })*/
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.didLogOut = true
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
