//
//  PassportPreviewViewModel.swift
//  ProfileModule
//
//  Created by hendra on 20/10/24.
//

import Foundation
import RepositoryModule
import UIKit
import VisionKit
import Vision
import SwiftUI

enum SavePassportState {
    case idle
    case loading
    case error
    case success
}

enum DeletePassportState {
    case idle
    case loading
    case error
    case success
}

public enum PassportPreviewOrigin: Equatable {
    case cameraScanner
    case imagePicker
}

@MainActor
class PassportPreviewViewModel: ObservableObject {
    @MainActor
    private var passportUseCase: PassportUseCaseProtocol = PassportUseCase.make()
    
    @MainActor
    private var accountUseCase: AccountUseCaseProtocol = AccountUseCase.make()
    
    //Data
    @Published var passport: PassportEntity
    @StateObject public var account: AccountEntity
    @Published var passportImage: UIImage?
    
    //Navigation
    @Published var isCameraOpen: Bool = false
    @Published var isImagePickerOpen: Bool = false
    
    //State View
    @Published var savePassportState: SavePassportState = .idle
    @Published var deletePassportState: DeletePassportState = .idle
    
    init(account: AccountEntity? = nil) {
        self._account = StateObject(wrappedValue: account ?? AccountEntity(id: "", username: "", image: Data()))
        
        if let account = account, let passportData = account.passport {
            self.passport = passportData
            self.passportImage = UIImage(data: passportData.image)
            isCameraOpen = false
        } else {
            self.passport = PassportEntity(id: UUID().uuidString, passportType: .regular, passportIssueType: .passportPolycarbonate, passportIssuePlace: "", issueDate: Date(), expirationDate: Date(), passportNo: "", image: Data())
        }
    }
    
    func savePassportData() async throws -> Bool {
        let isSuccess = try await passportUseCase.save(param: passport)
        account.passport = passport
        let isAccountSaveSuccess = try await accountUseCase.update(param: account)
        return isSuccess && isAccountSaveSuccess
    }
    
    func updatePassportData() async throws -> Bool {
        let isSuccess = try await passportUseCase.update(param: passport)
        return isSuccess
    }
    
    func savePassport() async {
        do {
            savePassportState = .loading
            if let image = passportImage, let imageData = image.pngData() {
                passport.image = imageData
                
                if let existingPassport = account.passport {
                    passport.id = existingPassport.id
                    let isSuccess = try await updatePassportData()
                    if !isSuccess {
                        savePassportState = .error
                        return
                    }
                } else {
                    let isSuccess = try await savePassportData()
                    if !isSuccess {
                        savePassportState = .error
                        return
                    }
                }
                savePassportState = .success
            }
        } catch {
            savePassportState = .error
        }
    }
    
    func deletePassport() async {
        do {
            deletePassportState = .loading
            if let passport = account.passport {
                let isSuccess = try await passportUseCase.delete(id: passport.id)
                if !isSuccess {
                    deletePassportState = .error
                }
            }
            
            self.passport = PassportEntity(
                id: UUID().uuidString,
                passportType: .regular,
                passportIssueType: .passportPolycarbonate,
                passportIssuePlace: "",
                issueDate: Date(),
                expirationDate: Date(),
                passportNo: "",
                image: Data()
            )
            
            self.passportImage = nil
            
            account.passport = nil
            
            let isAccountSaveSuccess = try await accountUseCase.update(param: account)
            if !isAccountSaveSuccess {
                deletePassportState = .error
                return
            }
            
            deletePassportState = .success
        } catch {
            deletePassportState = .error
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
                self.extractPassportData(from: recognizedTextByPosition)
                
                if let imageData = image.pngData() {
                    self.passport.image = imageData
                    self.passportImage = image
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
    
    @MainActor
    private func extractPassportData(from recognizedTextByPosition: [(text: String, boundingBox: CGRect)]) {
        if let image = passportImage {
            let extractedData = self.passportUseCase.extractData(from: recognizedTextByPosition, image: image)
            
            DispatchQueue.main.async {
                self.passport = extractedData
                self.passportImage = image
            }
        }
    }
}
