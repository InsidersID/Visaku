//
//  AdditionalInformationViewModel.swift
//  Visaku
//
//  Created by hendra on 07/11/24.
//

import Foundation
import RepositoryModule

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
@Observable
class AdditionalInformationViewModel {
    private var additionalInformationUseCase: AdditionalInformationUseCaseProtocol = AdditionalInformationUseCase.make()
    private var accountUseCase: AccountUseCaseProtocol = AccountUseCase.make()
    
    //Navigation
    var showJobSheet: Bool = false
    var showBornName: Bool = false
    
    //Data
    var additionalInformation: AdditionalInformationEntity
    var account: AccountEntity
    let jobOptions = [
        "Petani", "Arsitek", "Pengrajin", "Profesi Hukum (hakim/jaksa)",
        "Seniman", "Bankir", "Dealer", "Eksekutif Bisnis", "Pemimpin Agama/Religius",
        "Pengemudi", "Peneliti", "Guru", "Karyawan", "Politikus", "IT",
        "Tenaga ahli elektronik", "Ahli kimia", "Teknikal lainnya", "Jurnalis",
        "Profesi di bidang Kesehatan", "Maritim", "Buruh", "Freelancer",
        "Fashion/busana dan Komestik", "Polisi/Militer", "Pensiunan", "Peserta Pelatihan Kerja/Magang/Siswa",
        "Diplomat", "Tenaga administratif, teknis, dan pelayanan", "Tenaga hukum (pengacara/penasihat hukum)",
        "Eksekutif Perusahaan", "Beberapa macam"
    ]
    
    var searchJobQuery: String = ""
    
    var filteredJobs: [String] {
        jobOptions.filter { job in
            searchJobQuery.isEmpty || job.localizedCaseInsensitiveContains(searchJobQuery)
        }
    }
    
    //State View
    var saveAdditionalInformationState: SaveAdditionalInformationState = .idle
    var deleteAdditionalInformationState: DeleteAdditionalInformationState = .idle
    
    init(account: AccountEntity) {
        self.account = account
        if let additionalInformationData = account.additionalInformation {
            self.additionalInformation = additionalInformationData
        } else {
            self.additionalInformation = AdditionalInformationEntity(id: UUID().uuidString, bornName: "a", bornCountry: "a", bornNationality: "a", addressPostalCode: "a", addressCity: "a", addressCountry: "", addressFaximile: "a", addressTelephone: "a", addressEmail: "", selectedJob: "a", companyName: "a", companyAddress: "a", companyCity: "a", companyCountry: "a", companyPostalCode: "a", companyFaximile: "a", companyTelephone: "a", companyEmail: "a")
        }
    }
    
    @MainActor
    func saveAdditionalInformation() async {
        saveAdditionalInformationState = .loading
        do {
            var isSuccess: Bool
            print("before save \(additionalInformation.id)")
            var existingInformation: AdditionalInformationEntity?
            if var existingInfo = account.additionalInformation {
                // Update existing information
                print("triggered update \(existingInfo.id)")
                existingInformation = existingInfo
                // Update existingInfo's properties with values from additionalInformation
                existingInfo.bornName = additionalInformation.bornName
                existingInfo.bornCountry = additionalInformation.bornCountry
                existingInfo.bornNationality = additionalInformation.bornNationality

                isSuccess = try await additionalInformationUseCase.update(param: existingInfo)
                print("update successfully \(existingInfo.id)")
            } else {
                // Prepare new information
                if !showBornName {
                    self.additionalInformation.bornName = ""
                }
                isSuccess = try await additionalInformationUseCase.save(param: self.additionalInformation)
                print("save successfully \(additionalInformation.id)")
            }

            guard isSuccess else {
                saveAdditionalInformationState = .error
                return
            }

            var updatedAccount = account
            updatedAccount.additionalInformation = existingInformation ?? self.additionalInformation
            let isAccountSaveSuccess = try await accountUseCase.update(param: updatedAccount)

            guard isAccountSaveSuccess else {
                saveAdditionalInformationState = .error
                return
            }

            // Refetch the updated account
            if let existAccount = try await accountUseCase.fetchById(id: account.id) {
                account = existAccount
            }
            saveAdditionalInformationState = .success

        } catch {
            saveAdditionalInformationState = .error
            print("Save failed with error: \(error)")
        }
    }
    
    func deleteAdditionalInformation() async {
        do {
            deleteAdditionalInformationState = .loading
            if let additionalInformation = account.additionalInformation {
                let isSuccess = try await additionalInformationUseCase.delete(id: additionalInformation.id)
                if !isSuccess {
                    deleteAdditionalInformationState = .error
                }
            }
            
            self.additionalInformation = AdditionalInformationEntity(id: UUID().uuidString, bornName: "", bornCountry: "", bornNationality: "", addressPostalCode: "", addressCity: "", addressCountry: "", addressFaximile: "", addressTelephone: "", addressEmail: "", selectedJob: "", companyName: "", companyAddress: "", companyCity: "", companyCountry: "", companyPostalCode: "", companyFaximile: "", companyTelephone: "", companyEmail: "")
            
            deleteAdditionalInformationState = .success
        } catch {
            deleteAdditionalInformationState = .error
        }
    }
}
