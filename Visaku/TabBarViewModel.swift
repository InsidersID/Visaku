import Foundation

class FirstTimeUseManager {
    private let userDefaultsKey = "isFirstTimeUse"
    
    /// Checks and updates the first-use flag.
    /// - Returns: true if it's the first use, false otherwise.
    func checkAndSetFirstUse() -> Bool {
        let isFirstTime = !UserDefaults.standard.bool(forKey: userDefaultsKey)
        
        if isFirstTime {
            UserDefaults.standard.set(true, forKey: userDefaultsKey)
        }
        
        return isFirstTime
    }
}
