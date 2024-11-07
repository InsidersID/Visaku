import Foundation
import RepositoryModule

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
    
    var error: CustomError?
    
    func fetchAccount() async {
        do {
            accounts = try await accountUseCase.fetch()
        } catch {
            print(error)
        }
    }
    
    func saveAccount() async {
        do {
            isLoading = true
            let isSuccess = try await accountUseCase.save(param: AccountEntity(id: UUID().uuidString, username: username))
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
}

