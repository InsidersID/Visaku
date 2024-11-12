import SwiftUI
import UIComponentModule
import RepositoryModule

struct AdditionalInformationView: View {
    @State private var hasDifferentBirthName: Bool? = nil
    @Environment(\.dismiss) var dismiss
//    @Environment(ProfileViewModel.self) var profileViewModel
    @State var additionalInformationViewModel: AdditionalInformationViewModel
    
    public init(account: AccountEntity) {
        self.additionalInformationViewModel = AdditionalInformationViewModel(account: account)
    }
    
    
    var body: some View {
//        @Bindable var profileViewModel = profileViewModel
        
        ScrollView {
            VStack(alignment: .center) {
                Image("form_aset")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                
                Text("Informasi Personal")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ExpandableRadioButton(
                    title: "Apakah ada nama lahir yang berbeda? (Opsional)",
                    options: ["Ya", "Tidak"],
                    selection: $hasDifferentBirthName
                )
                
                if hasDifferentBirthName ?? false {
                    FormField(
                        title: "Nama lahir yang berbeda",
                        text: $additionalInformationViewModel.additionalInformation.bornName
                    )
                }
                
                FormField(title: "Negara tempat anda lahir", text: $additionalInformationViewModel.additionalInformation.bornCountry)
                
                FormField(title: "Kebangsaan anda saat lahir (Opsional)", text: $additionalInformationViewModel.additionalInformation.bornNationality)
                
                Text("Alamat Rumah")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                FormField(title: "Kode Pos Rumah saat ini", text: $additionalInformationViewModel.additionalInformation.addressPostalCode)
                
                FormField(title: "Kota tempat tinggal saat ini", text: $additionalInformationViewModel.additionalInformation.addressCity)
                
                FormField(title: "Negara tempat tinggal saat ini", text: $additionalInformationViewModel.additionalInformation.addressCountry)
                
                FormField(title: "Nomor fax yang bisa dihubungi (Opsional)", text: $additionalInformationViewModel.additionalInformation.addressFaximile)
                
                FormField(title: "Nomor telepon / HP aktif yang dapat dihubungi (Opsional)", text: $additionalInformationViewModel.additionalInformation.addressTelephone)
                
                FormField(title: "Alamat email aktif", text: $additionalInformationViewModel.additionalInformation.addressEmail)
                
                Text("Pekerjaan")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CardContainer(cornerRadius: 12) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("Pekerjaan saat ini")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(additionalInformationViewModel.additionalInformation.selectedJob.isEmpty ?  "Jawaban": additionalInformationViewModel.additionalInformation.selectedJob)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .onTapGesture {
                    additionalInformationViewModel.showJobSheet.toggle()
                }
                
                FormField(title: "Nama perusahaan atau institusi", text: $additionalInformationViewModel.additionalInformation.companyName)
                FormField(title: "Alamat lengkap perusahaan", text: $additionalInformationViewModel.additionalInformation.companyAddress)
                FormField(title: "Kota perusahaan", text: $additionalInformationViewModel.additionalInformation.companyCity)
                FormField(title: "Negara perusahaan", text: $additionalInformationViewModel.additionalInformation.companyCountry)
                FormField(title: "Kode pos perusahaan", text: $additionalInformationViewModel.additionalInformation.companyPostalCode)
                FormField(title: "Nomor fax", text: $additionalInformationViewModel.additionalInformation.companyFaximile)
                FormField(title: "Nomor telepon", text: $additionalInformationViewModel.additionalInformation.companyTelephone)
                FormField(title: "Email", text: $additionalInformationViewModel.additionalInformation.companyEmail)
                
                switch additionalInformationViewModel.saveAdditionalInformationState {
                case .loading:
                    ProgressView("Saving...")
                        .padding()
                case .error:
                    Text("Error saving the Additional Information").foregroundColor(.red)
                case .success:
                    Text("Additional Information saved successfully").foregroundColor(.green)
                case .idle:
                    CustomButton(text: "Selanjutnya", color: Color.primary5) {
                        Task {
                            await additionalInformationViewModel.saveAdditionalInformation()
//                            $profileViewModel.selectedAccount = additionalInformationViewModel.account
                        }
                        dismiss()
                    }
                }
                
                
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Informasi Tambahan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "x.circle")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $additionalInformationViewModel.showJobSheet) {
            VStack(alignment: .leading) {
                Text("Pilih Pekerjaan")
                    .font(.headline)
                    .padding()
                
                TextField("Cari pekerjaan...", text: $additionalInformationViewModel.searchJobQuery)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                List(additionalInformationViewModel.filteredJobs, id: \.self) { job in
                    Text(job)
                        .onTapGesture {
                            additionalInformationViewModel.additionalInformation.selectedJob = job
                            additionalInformationViewModel.showJobSheet.toggle()
                        }
                }
            }
        }
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    @State var isExpanded: Bool = true
    
    var body: some View {
        CardContainer(cornerRadius: 12) {
            VStack(alignment: .leading) {
                
                
                if isExpanded {
                    HStack {
                        Text(title)
                        Spacer()
                        Image(systemName: "chevron.up")
                    }
                    .onTapGesture {
                        isExpanded = false
                    }
                    
                    TextField(title, text: $text)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        .font(.body)
                        .padding(.top, 8)
                        .onSubmit {
                            isExpanded = false
                        }
                } else {
                    HStack {
                        Text(title)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    
                    Text(text)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .onTapGesture {
            isExpanded = true
        }
    }
}

struct RadioButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                    .padding(.vertical, 0)
                Text(label)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct ExpandableRadioButton: View {
    let title: String
    let options: [String]
    @Binding var selection: Bool?

    @State private var isExpanded: Bool = true

    public var body: some View {
        CardContainer(cornerRadius: 12) {
            VStack(spacing: 16) {
                HStack {
                    Text(title)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    isExpanded.toggle()
                }
                
                
                if isExpanded {
                    VStack(alignment: .leading) {
                        Divider()
                        RadioButton(label: options[0], isSelected: selection == true) {
                            selection = true
                            isExpanded = false
                        }
                        Divider()
                        RadioButton(label: options[1], isSelected: selection == false) {
                            selection = false
                            isExpanded = false
                        }
                    }
                } else {
                    Text(selectedOption)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    public var selectedOption: String {
        if selection == true {
            return options[0]
        } else if selection == false {
            return options[1]
        } else {
            return ""
        }
    }
}


#Preview {
    AdditionalInformationView(account: .init(id: UUID().uuidString, username: "", image: Data()))
}
