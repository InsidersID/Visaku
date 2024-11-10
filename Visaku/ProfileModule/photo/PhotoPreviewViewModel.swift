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
class PhotoPreviewViewModel: ObservableObject {
    @MainActor
    private var accountUseCase: AccountUseCaseProtocol = AccountUseCase.make()
    
    //Navigation
    var isCameraOpen: Bool = true
    
    var account: AccountEntity
    @Published var photoImage: UIImage?
    
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
                    print("savePhoto: Save photo successful with empty id")
                    isSuccess = try await accountUseCase.updateAccountImage(id: account.id, imageData: imageData)
                } else {
                    print("savePhoto: Save photo successful with existing id")
                    isSuccess = try await accountUseCase.save(param: account)
                }
                
                if !isSuccess {
                    print("savePhoto: Save photo failed!")
                    savePhotoState = .error
                    return
                }
                
                print("savePhoto: Save photo success!")
                savePhotoState = .success
            }
        } catch {
            print("savePhoto: Save photo error...")
            savePhotoState = .error
        }
    }
    
    func deletePhoto() async {
        do {
            deletePhotoState = .loading
            let isSuccess = try await accountUseCase.deleteAccountImage(id: account.id)
            
            if !isSuccess {
                print("savePhoto: Delete photo failed...")
                deletePhotoState = .error
                return
            }
            print("savePhoto: Delete photo success!")
            deletePhotoState = .success
        } catch {
            print("savePhoto: Delete photo error...")
            deletePhotoState = .error
        }
    }
    
}
