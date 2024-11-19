import Foundation
import LocalAuthentication

@MainActor
@Observable
class TabBarViewModel{
    var isUnlocked: Bool = false
    var navigateToContentUnavailableView: Bool = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Harap buka kunci perangkat untuk mengakses aplikasi"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.navigateToContentUnavailableView = true
                        print("Authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        } else {
            // Handle the case where biometrics are not available
            print("Biometrics are not available: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}

class AgreementManager {
    private let agreementKey = "userHasAgreed"
    
    func checkAgreement() -> Bool {
        return !UserDefaults.standard.bool(forKey: agreementKey)
    }
    
    func setAgreed() {
        UserDefaults.standard.set(true, forKey: agreementKey)
    }
}
