import Foundation
import Combine
import FirebaseAuth

class AuthService: AuthAPI {
    static let shared = AuthService()

    func addListener() -> Future<User?, Never> {
        return Future<User?, Never> { promise in
            Auth.auth().addStateDidChangeListener {(auth, firebaseUser) in
                guard let firebaseUser = firebaseUser else {
                    promise(.success(nil))
                    return
                }
                let id = firebaseUser.uid
                let email = firebaseUser.email ?? ""
                let user = User(id: id, email: email)
                promise(.success(user))
            }
        }
    }
    
    func login(email: String, password: String) -> Future<User?, Never> {
        return Future<User?, Never> { promise in
            Auth.auth().signIn(withEmail: email, password: password) {(authResult, _) in
                guard let id = authResult?.user.providerID,
                    let email = authResult?.user.email else {
                        promise(.success(nil))
                        return
                }
                let user = User(id: id, email: email)
                promise(.success(user))
            }
        }
    }
    
    func signUp(email: String, password: String) -> Future<User?, Never> {
        return Future<User?, Never> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, _) in
                guard let id = authResult?.user.providerID,
                    let email = authResult?.user.email else {
                        promise(.success(nil))
                        return
                }
                let user = User(id: id, email: email)
                promise(.success(user))
            }
        }
    }
}
