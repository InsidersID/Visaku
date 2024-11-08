import SwiftUI
import RepositoryModule
import UIComponentModule

struct Document: Identifiable {
    let id = UUID()
    let name: String
}

public struct MainDocumentView: View {
    public var name: String
    @Environment(\.dismiss) private var dismiss
    @Environment(ProfileViewModel.self) var profileViewModel
    @State private var scanResult: UIImage?
    public var account: AccountEntity
    @State private var isDocumentTapped: Bool
    @State private var selectedDocument: Document?
    
    public init(name: String, account: AccountEntity, isDocumentTapped: Bool = false) {
        self.name = name
        self.account = account
        self.isDocumentTapped = isDocumentTapped
    }
    
    public var body: some View {
        @Bindable var profileViewModel = profileViewModel
        
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
                                    DocumentCard(height: proxy.size.height*102/798, document: "KTP", status: account.identityCard == nil ? .undone : .done)
                                }
                                
                                Button {
                                    selectedDocument = .init(name: "Paspor")
                                    isDocumentTapped = true
                                } label: {
                                    DocumentCard(height: proxy.size.height*102/798, document: "Paspor", status: account.passport == nil ? .undone : .done)
                                }
                            }
                            
                            Button {
                                selectedDocument = .init(name: "Foto")
                                isDocumentTapped = true
                            } label: {
                                DocumentCard(height: proxy.size.height*102/798, document: "Foto", status: .undone)
                            }
                            
                            NavigationLink {
                                AddOnInformationView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                DocumentCard(height: proxy.size.height*102/798, document: "Informasi tambahan", status: .undone)
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
            .fullScreenCover(isPresented: $profileViewModel.isScanKTP, content: {
                KTPPreviewSheet(account: account)
            })
            .fullScreenCover(isPresented: $profileViewModel.isScanPaspor, content: {
                PassportPreviewSheet(account: account)
            })
            .fullScreenCover(isPresented: $profileViewModel.isScanFoto, content: {
                EmptyView()
            })
            .sheet(item: $selectedDocument, content: { document in
                DocumentDetailsView(document: document.name, account: account)
                    .presentationDragIndicator(.visible)
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
        }
    }
}

#Preview {
    MainDocumentView(name: "Iqbal", account: AccountEntity(id: "1", username: "IqbalGanteng"))
        .environment(ProfileViewModel())
}
