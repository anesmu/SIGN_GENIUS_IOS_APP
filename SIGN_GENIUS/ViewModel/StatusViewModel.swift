import Foundation

class StatusViewModel: Identifiable, ObservableObject {
    
    var title: String
    var message: String
    
    init(title: String = "", message: String = "") {
        self.title = title
        self.message = message
    }

    static var signUpSuccessStatus: StatusViewModel {
        return StatusViewModel(title: NSLocalizedString("SignUpSuccessStatusTitle", comment: ""), message: NSLocalizedString("SignUpSuccessStatusMessage", comment: ""))
    }
    
    static var logInSuccessStatus: StatusViewModel {
        return StatusViewModel(title: NSLocalizedString("LogInSuccessStatusTitle", comment: ""), message: NSLocalizedString("LogInSuccessStatusMessage", comment: ""))
    }
    
    static var passwordResetSuccessStatus: StatusViewModel {
        return StatusViewModel(title: NSLocalizedString("PasswordResetSuccessStatusTitle", comment: ""), message: NSLocalizedString("PasswordResetSuccessStatusMessage", comment: ""))
    }
    
    static var errorStatus: StatusViewModel {
        return StatusViewModel(title: NSLocalizedString("ErrorStatusTitle", comment: ""), message: NSLocalizedString("ErrorStatusMessage", comment: ""))
    }
}
