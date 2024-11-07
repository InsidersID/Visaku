import SwiftUI
import UIComponentModule
import RepositoryModule

struct AdditionalInformationView: View {
    @Environment(\.dismiss) var dismiss
    @State var additionalInformationViewModel: AdditionalInformationViewModel
    
    public init(account: AccountEntity) {
        self.additionalInformationViewModel = AdditionalInformationViewModel(account: account)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Image("form_aset")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                
                Text("Pekerjaan")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
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
                        }
                        dismiss()
                    }
                }
                
                
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Informasi Tambahan")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "x.circle")
                        .font(.title)
                        .foregroundColor(.blue)
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

#Preview {
    AdditionalInformationView(account: .init(id: UUID().uuidString, username: ""))
}

struct FormField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        CardContainer(cornerRadius: 25) {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                    Spacer()
                    Image(systemName: "chevron.up")
                }
                
                TextField(title, text: $text)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.black)
                    .font(.body)
                    .padding(.top, 8)
            }
        }
    }
}
