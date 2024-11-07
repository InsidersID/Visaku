import SwiftUI

struct CustomError: LocalizedError {
    var errorDescription: String?
    
    init(_ description: String) {
        self.errorDescription = description
    }
}
