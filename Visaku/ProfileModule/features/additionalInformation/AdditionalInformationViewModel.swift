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
            self.additionalInformation = AdditionalInformationEntity(id: UUID().uuidString, selectedJob: "", companyName: "", companyAddress: "", companyCity: "", companyCountry: "", companyPostalCode: "", companyFaximile: "", companyTelephone: "", companyEmail: "")
        }
    }
    
    func saveAdditionalInformation() async {
        do {
            saveAdditionalInformationState = .loading
            if let additionalInformation = account.additionalInformation {
                self.additionalInformation.id = additionalInformation.id
                let isSuccess = try await additionalInformationUseCase.update(param: additionalInformation)
                if !isSuccess {
                    saveAdditionalInformationState = .error
                    return
                }
            } else {
                let isSuccess = try await additionalInformationUseCase.save(param: additionalInformation)
                if !isSuccess {
                    saveAdditionalInformationState = .error
                    return
                }
            }
            
            account.additionalInformation = additionalInformation
            let isAccountSaveSuccess = try await accountUseCase.update(param: account)
            if !isAccountSaveSuccess {
                saveAdditionalInformationState = .error
                return
            }
            
            saveAdditionalInformationState = .success
        } catch {
            saveAdditionalInformationState = .error
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
            
            self.additionalInformation = AdditionalInformationEntity(id: UUID().uuidString, selectedJob: "", companyName: "", companyAddress: "", companyCity: "", companyCountry: "", companyPostalCode: "", companyFaximile: "", companyTelephone: "", companyEmail: "")
            
            deleteAdditionalInformationState = .success
        } catch {
            deleteAdditionalInformationState = .error
        }
    }
}
