//
//  PhotoPreviewViewModel.swift
//  Visaku
//
//  Created by Lonard Steven on 08/11/24.
//

import Foundation
import RepositoryModule
import UIKit

enum SavePhotoState {
    case idle
    case loading
    case error
    case success
}

enum DeletePhotoState  {
    case idle
    case loading
    case error
    case success
}

@MainActor
@Observable
class PhotoPreviewViewModel {
    @MainActor
    private var accountUseCase: AccountUseCaseProtocol = AccountUseCase.make()
    
    //Navigation
    var isCameraOpen: Bool = true
    
    var account: AccountEntity
    var photoImage: UIImage?
    
    //State View
    var savePhotoState: SavePhotoState = .idle
    var deletePhotoState: DeletePhotoState = .idle
    
    init(account: AccountEntity) {
        self.account = account
        
        if self.account.image == Data() {
            isCameraOpen = true
        } else {
            self.photoImage = UIImage(data: account.image)
            isCameraOpen = false
        }

    }
    
    func savePhoto() async {
        do {
            savePhotoState = .loading
            if let image = photoImage, let imageData = image.pngData() {
                account.image = imageData
                
                let isSuccess: Bool
                if account.id.isEmpty {
                    isSuccess = try await accountUseCase.updateAccountImage(id: account.id, imageData: imageData)
                } else {
                    isSuccess = try await accountUseCase.save(param: account)
                }
                
                if !isSuccess {
                    savePhotoState = .error
                    return
                }
                
                savePhotoState = .success
            }
        } catch {
            savePhotoState = .error
        }
    }
    
    func deletePhoto() async {
        do {
            deletePhotoState = .loading
            let isSuccess = try await accountUseCase.deleteAccountImage(id: account.id)
            
            if !isSuccess {
                deletePhotoState = .error
                return
            }
            
            deletePhotoState = .success
        } catch {
            deletePhotoState = .error
        }
    }
    
}
