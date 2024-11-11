//
//  AdditionalInformationViewModel.swift
//  Visaku
//
//  Created by hendra on 07/11/24.
//

import Foundation
import RepositoryModule

@MainActor
class AdditionalInformationViewModel: ObservableObject {
    private var additionalInformationUseCase: AdditionalInformationUseCaseProtocol = AdditionalInformationUseCase.make()
    private var accountUseCase: AccountUseCaseProtocol = AccountUseCase.make()
    
    //Navigation
    @Published var showJobSheet: Bool = false
    @Published var showBornName: Bool = false
    
    //Data
    @Published var additionalInformation: AdditionalInformationEntity
    @Published var account: AccountEntity
    @Published var jobOptions = [
        "Petani", "Arsitek", "Pengrajin", "Profesi Hukum (hakim/jaksa)",
        "Seniman", "Bankir", "Dealer", "Eksekutif Bisnis", "Pemimpin Agama/Religius",
        "Pengemudi", "Peneliti", "Guru", "Karyawan", "Politikus", "IT",
        "Tenaga ahli elektronik", "Ahli kimia", "Teknikal lainnya", "Jurnalis",
        "Profesi di bidang Kesehatan", "Maritim", "Buruh", "Freelancer",
        "Fashion/busana dan Komestik", "Polisi/Militer", "Pensiunan", "Peserta Pelatihan Kerja/Magang/Siswa",
        "Diplomat", "Tenaga administratif, teknis, dan pelayanan", "Tenaga hukum (pengacara/penasihat hukum)",
        "Eksekutif Perusahaan", "Beberapa macam"
    ]
    
    @Published var searchJobQuery: String = ""
    
    var filteredJobs: [String] {
        jobOptions.filter { job in
            searchJobQuery.isEmpty || job.localizedCaseInsensitiveContains(searchJobQuery)
        }
    }
    
    //State View
    @Published var saveAdditionalInformationState: SaveAdditionalInformationState = .idle
    @Published var deleteAdditionalInformationState: DeleteAdditionalInformationState = .idle
    
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
            if var existingAdditionalInformation = account.additionalInformation {
                isSuccess = try await updateAdditionalInformationData()
            } else {
                isSuccess = try await saveAdditionalInformationData()
            }
            
            if !isSuccess {
                saveAdditionalInformationState = .error
                return
            }
            saveAdditionalInformationState = .success
            await updateUIData()
        } catch {
            saveAdditionalInformationState = .error
            print("Save failed with error: \(error)")
        }
    }
    
    private func updateUIData() async {
        do {
            let account = try await accountUseCase.fetchById(id: account.id)
            if let additionalInformation = account?.additionalInformation {
                self.additionalInformation = additionalInformation
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    private func saveAdditionalInformationData() async throws -> Bool {
        let isSuccess = try await additionalInformationUseCase.save(param: additionalInformation)
        if !isSuccess {
            return false
        }
        account.additionalInformation = additionalInformation
        return try await accountUseCase.update(param: account)
    }
    
    private func updateAdditionalInformationData() async throws -> Bool {
        if let existingAdditionalInformation = account.additionalInformation {
            additionalInformation.id = existingAdditionalInformation.id
            return try await additionalInformationUseCase.update(param: additionalInformation)
        }
        return false
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
