import Foundation
import SwiftUI
import RepositoryModule
import UIKit
import VisionKit
import Vision

enum SaveIdentityCardState {
    case idle
    case loading
    case error
    case success
}

enum DeleteIdentityCardState {
    case idle
    case loading
    case error
    case success
}

public enum KTPPreviewOrigin: Equatable {
    case cameraScanner
    case imagePicker
}

@MainActor
class KTPPreviewViewModel: ObservableObject {
    @MainActor
    private var identityCardUseCase: IdentityCardUseCaseProtocol = IdentityCardUseCase.make()
    
    @MainActor
    private var accountUseCase: AccountUseCaseProtocol = AccountUseCase.make()
    
    //Navigation
    @Published var isCameraOpen: Bool = false
    
    //Data
    @Published var identityCard: IdentityCardEntity
    @StateObject public var account: AccountEntity
    @Published var ktpImage: UIImage?
    
    //State View
    @Published var saveIdentityCardState: SaveIdentityCardState = .idle
    @Published var deleteIdentityCardState: DeleteIdentityCardState = .idle
    
    
    init(account: AccountEntity? = nil) {
        self._account = StateObject(wrappedValue: account ?? AccountEntity(id: "", username: "", image: Data()))
        
        if let account = account, let identityCardData = account.identityCard {
            self.identityCard = identityCardData
            self.ktpImage = UIImage(data: identityCardData.image)
            isCameraOpen = false
        } else {
            self.identityCard = IdentityCardEntity(id: UUID().uuidString, identityId: "", name: "", placeDateOfBirth: "", gender: .male, address: "", countryBorn: "", nationality: "", maritalStatus: .single, job: "", image: Data())
        }
    }
    
    private func saveIdentityData() async throws -> Bool {
        let isSuccess = try await identityCardUseCase.save(param: identityCard)
        account.identityCard = identityCard
        
        let isAccountSaveSuccess = try await accountUseCase.update(param: account)
        return isSuccess && isAccountSaveSuccess
    }
    
    private func updateIdentityData() async throws -> Bool {
        let isSuccess = try await identityCardUseCase.update(param: identityCard)
        return isSuccess
    }
    
    func saveIdentityCard() async {
        do {
            saveIdentityCardState = .loading
            if let image = ktpImage, let imageData = image.pngData() {
                identityCard.image = imageData
                
                if let existingCard = account.identityCard {
                    identityCard.id = existingCard.id
                    let isSuccess = try await updateIdentityData()
                    if !isSuccess {
                        saveIdentityCardState = .error
                        return
                    }
                } else {
                    let isSuccess = try await saveIdentityData()
                    if !isSuccess {
                        saveIdentityCardState = .error
                        return
                    }
                }
                saveIdentityCardState = .success
            }
        } catch {
            saveIdentityCardState = .error
        }
    }
    
    func deleteIdentityCard() async {
        do {
            deleteIdentityCardState = .loading
            if let identityCard = account.identityCard {
                let isSuccess = try await identityCardUseCase.delete(id: identityCard.id)
                if !isSuccess {
                    deleteIdentityCardState = .error
                }
            }
            
            self.identityCard = IdentityCardEntity(id: UUID().uuidString, identityId: "", name: "", placeDateOfBirth: "", gender: .male, address: "", countryBorn: "", nationality: "", maritalStatus: .single, job: "", image: Data())
            self.ktpImage = nil
            
            account.identityCard = nil
            
            
            let isAccountSaveSuccess = try await accountUseCase.update(param: account)
            if !isAccountSaveSuccess {
                deleteIdentityCardState = .error
                return
            }
            
            deleteIdentityCardState = .success
        } catch {
            deleteIdentityCardState = .error
        }
    }
    
    func processCapturedImage(_ image: UIImage) {
        guard let ciImage = image.ciImage ?? CIImage(image: image) else {
            print("Failed to convert UIImage to CIImage")
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("Text recognition error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            var recognizedTextByPosition = [(text: String, boundingBox: CGRect)]()
            
            for observation in observations {
                if let topCandidate = observation.topCandidates(1).first {
                    recognizedTextByPosition.append((text: topCandidate.string, boundingBox: observation.boundingBox))
                }
            }
            
            DispatchQueue.main.async {
                self.extractIdentityCardData(from: recognizedTextByPosition)
                if let imageData = image.pngData() {
                    self.identityCard.image = imageData
                    self.ktpImage = image
                } else {
                    print("Failed to convert UIImage to Data")
                }
            }
        }
        
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error.localizedDescription)")
        }
    }
    
    private func extractIdentityCardData(from recognizedTextByPosition: [(text: String, boundingBox: CGRect)]) {
        if let image = ktpImage {
            let extractedData = self.identityCardUseCase.extractData(from: recognizedTextByPosition, image: image)
            
            DispatchQueue.main.async {
                self.identityCard = extractedData
                self.ktpImage = image
//                self.isCameraOpen = false
            }
        }
    }
}
