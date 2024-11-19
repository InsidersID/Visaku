import Foundation

class AgreementManager {
    private let agreementKey = "userHasAgreed"
    
    func checkAgreement() -> Bool {
        return !UserDefaults.standard.bool(forKey: agreementKey)
    }
    
    func setAgreed() {
        UserDefaults.standard.set(true, forKey: agreementKey)
    }
}
