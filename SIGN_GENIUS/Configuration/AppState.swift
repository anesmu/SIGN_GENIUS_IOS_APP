import SwiftUI
import FirebaseAuth
import Combine

class AppState: ObservableObject {
    @Published var didLogOut: Bool = false
    var currentUser: User?
    let authService = AuthService()
    
    init() {
        if let firebaseUser = Auth.auth().currentUser {
            let id = firebaseUser.uid
            let email = firebaseUser.email ?? ""
            self.currentUser = User(id: id, email: email)
        }
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
