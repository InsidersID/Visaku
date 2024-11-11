import SwiftUI
import RepositoryModule
import UIComponentModule

struct Document: Identifiable {
    let id = UUID()
    let name: String
}

public struct MainDocumentView: View {
    public var name: String
    public var accountId: String
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var scanResult: UIImage?
    @State private var isDocumentTapped: Bool
    @State private var selectedDocument: Document?
    @State private var isAdditionalInfoPresented: Bool = false
    @State private var needsFetch: Bool = true
    
    public init(name: String, accountId: String, isDocumentTapped: Bool = false) {
        self.name = name
        self.accountId = accountId
        self.isDocumentTapped = isDocumentTapped
    }
    
    public var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ZStack {
                    VStack {
                        Color(red: 0.2, green: 0.64, blue: 0.88)
                            .frame(height: proxy.size.height * 0.3)
                            .ignoresSafeArea()
                        
                        Spacer()
                    }
                    
                    VStack {
                        VStack {
                            Circle()
                                .foregroundStyle(Color(red: 0.85, green: 0.85, blue: 0.85))
                                .frame(width: 86, height: 86)
                            HStack {
                                Text(name)
                                    .font(Font.custom("Inter", size: 20))
                                    .fontWeight(.semibold)
                                
                                Image(systemName: "pencil")
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: proxy.size.width*0.03) {
                            HStack(spacing: proxy.size.width*0.03) {
                                Button {
                                    selectedDocument = .init(name: "KTP")
                                    isDocumentTapped = true
                                    
                                } label: {
                                    DocumentCard(height: proxy.size.height*102/798, document: "KTP", status: profileViewModel.selectedAccount?.identityCard == nil ? .undone : .done)
                                }
                                
                                Button {
                                    selectedDocument = .init(name: "Paspor")
                                    isDocumentTapped = true
                                } label: {
                                    DocumentCard(height: proxy.size.height*102/798, document: "Paspor", status: profileViewModel.selectedAccount?.passport == nil ? .undone : .done)
                                }
                            }
                            
                            Button {
                                selectedDocument = .init(name: "Foto")
                                isDocumentTapped = true
                            } label: {
                                DocumentCard(height: proxy.size.height*102/798, document: "Foto", status: .undone)
                            }
                            
                            Button {
                                isAdditionalInfoPresented = true
                            } label: {
                                DocumentCard(height: proxy.size.height * 102 / 798, document: "Informasi tambahan", status: .undone)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Button("Hapus Profil", role: .destructive){
                            profileViewModel.isDeleteProfile = true
                        }
                        .font(Font.system(size: 17))
                        .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    if profileViewModel.isDeleteProfile {
                        CustomAlert(title: "Hapus profil?", caption: "Jika dokumen dihapus, semua data akan hilang secara otomatis.", button1: "Hapus", button2: "Batal")
                    }
                }
            }
            .fullScreenCover(isPresented: $isAdditionalInfoPresented) {
                if let account = profileViewModel.selectedAccount {
                    AdditionalInformationView(account: account)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .sheet(item: $selectedDocument, content: { document in
                if let account = profileViewModel.selectedAccount {
                    DocumentDetailsView(document: document.name, account: account)
                        .presentationDragIndicator(.visible)
                }
            })
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profil")
                        .foregroundStyle(.white)
                        .font(Font.custom("Inter", size: 17))
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left.circle")
                            .foregroundStyle(.white)
                    }
                }
            }
            .onAppear {
                if needsFetch {
                    Task {
                        print("trigger fetch")
                        profileViewModel.selectedAccount = await profileViewModel.fetchAccountById(id: accountId)
                        needsFetch = false
                    }
                }
            }
            .onDisappear {
                needsFetch = true
                print("onDisappear")
            }
        }
    }
}

#Preview {
    MainDocumentView(name: "Iqbal", accountId: UUID().uuidString)
        .environmentObject(ProfileViewModel())
}
