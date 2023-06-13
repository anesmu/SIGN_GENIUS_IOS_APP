import FirebaseAuth

class PasswordResetViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    
    private let authAPI: AuthAPI
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    func passwordReset() {
        authAPI.resetPassword(email: email) { error in
            if let error = error {
                self.statusViewModel = StatusViewModel.errorStatus
            } else {
                self.statusViewModel = StatusViewModel.passwordResetSuccessStatus
            }
        }

    }
}
