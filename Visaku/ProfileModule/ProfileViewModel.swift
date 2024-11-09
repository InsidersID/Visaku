import Foundation
import RepositoryModule
import SwiftUI

@MainActor
@Observable
public class ProfileViewModel{
    
    private var accountUseCase: AccountUseCaseProtocol = AccountUseCase.make()
    var accounts: [AccountEntity]?
    var isAddingProfile: Bool = false
    var isDeleteProfile: Bool = false
    var isLoading: Bool = false
    var isError: Bool = false
    var username: String = ""
    var isScanKTP: Bool = false
    var isScanPaspor: Bool = false
    var isScanFoto: Bool = false
    var selectedDocument: Document?
    var uploadDocument: Document?
    var isUploadFile: Bool = false
    var isUploadImage: Bool = false
    var selectedFileURL: URL?
    var selectedImage: UIImage?
    var accountID: String?
    
    var error: CustomError?
    
    init(accountID: String? = nil) {
        self.accountID = accountID
        if let id = accountID {
            Task {
                await fetchAccountByID(id)
            }
        }
    }
    
    func fetchAccount() async {
        do {
            accounts = try await accountUseCase.fetch()
        } catch {
            print(error)
        }
    }
    
    func fetchAccountByID(_ id: String) async {
        do {
            if let account = try await accountUseCase.fetchById(id: id) {
                self.username = account.username
            }
        } catch {
            print("Error during account fetching: \(error.localizedDescription)")
        }
    }
    
    func saveAccount() async {
        do {
            isLoading = true
            let isSuccess = try await accountUseCase.save(param: AccountEntity(id: UUID().uuidString, username: username, image: Data()))
            if isSuccess {
                isLoading = false
                username = ""
                Task {
                    await fetchAccount()
                }
            }
            error = isSuccess ? nil: CustomError("Error saving account")
            
        } catch(let error) {
            self.error = CustomError(error.localizedDescription)
        }
    }
    
    func deleteAccount(_ account: AccountEntity) async {
        do {
            isLoading = true
            let isSuccess = try await accountUseCase.delete(id: account.id)
            if isSuccess {
                isLoading = false
                Task {
                    await fetchAccount()
                }
            }
        } catch {
            self.error = CustomError(error.localizedDescription)
        }
    }
    
    func updateAccount(_ account: AccountEntity) async {
        do {
            isLoading = true
            let isSuccess = try await accountUseCase.update(param: account)
            if isSuccess {
                isLoading = false
                Task {
                    await fetchAccount()
                }
            }
        } catch {
            self.error = CustomError(error.localizedDescription)
        }
    }
    
    func updateAccountUsername(_ account: AccountEntity, newUsername: String) async {
        do {
            isLoading = true
            let isSuccess = try await accountUseCase.updateUsername(id: account.id, newUsername: newUsername)
            if isSuccess {
                isLoading = false
                Task {
                    await fetchAccount()
                }
            }
        } catch {
            self.error = CustomError(error.localizedDescription)
        }
    }
}

