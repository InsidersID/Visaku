import Foundation
import RepositoryModule
import SwiftUI

enum SaveAdditionalInformationState {
    case idle
    case loading
    case error
    case success
}

enum DeleteAdditionalInformationState {
    case idle
    case loading
    case error
    case success
}

@MainActor
public class ProfileViewModel: ObservableObject {
    //ProfileView
    private var accountUseCase: AccountUseCaseProtocol = AccountUseCase.make()
    
    @Published var accounts: [AccountEntity]?
    @Published var isAddingProfile: Bool = false
    @Published var isDeleteProfile: Bool = false
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var username: String = ""
    
    @Published var selectedAccount: AccountEntity?
    
    @Published var error: CustomError?
    
    //AdditionalInformationView
    private var additionalInformationUseCase: AdditionalInformationUseCaseProtocol = AdditionalInformationUseCase.make()
    
    //Navigation
    @Published var showJobSheet: Bool = false
    @Published var showBornName: Bool = false
    
    
    
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
    
    func fetchAccountById(_ id: String) async {
        do {
            selectedAccount = try await accountUseCase.fetchById(id: id)
        } catch {
            print(error)
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
                    await fetchAccountByID(account.id)
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
                    await fetchAccountByID(account.id)
                }
            }
        } catch {
            self.error = CustomError(error.localizedDescription)
        }
    }
}

