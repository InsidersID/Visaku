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
    @State private var selectedDocument: Document?
    @State private var isAdditionalInfoPresented: Bool = false
    @State private var needsFetch: Bool = true
    @State private var isShowingEditProfile = false
    
    public init(name: String, accountId: String) {
        self.name = name
        self.accountId = accountId
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
                            Button(action: {
                                profileViewModel.selectedDocument = .init(name: "Foto")
                            }){
                                Circle()
                                    .foregroundStyle(Color(red: 0.85, green: 0.85, blue: 0.85))
                                    .frame(width: 86, height: 86)
                            }
                            
                            Button(action: {
                                isShowingEditProfile = true
                            }) {
                                HStack {
                                    Text(name)
                                        .font(Font.custom("Inter", size: 20))
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: "pencil")
                                }
                            }

                        }
                        
                        Spacer()
                        
                        VStack(spacing: proxy.size.width*0.03) {
                            HStack(spacing: proxy.size.width*0.03) {
                                Button {
                                    profileViewModel.selectedDocument = .init(name: "KTP")
                                    
                                } label: {
                                    DocumentCard(height: proxy.size.height*102/798, document: "KTP", status: profileViewModel.selectedAccount?.identityCard == nil ? .undone : .done)
                                }
                                
                                Button {
                                    profileViewModel.selectedDocument = .init(name: "Paspor")
                                } label: {
                                    DocumentCard(height: proxy.size.height*102/798, document: "Paspor", status: profileViewModel.selectedAccount?.passport == nil ? .undone : .done)
                                }
                            }
                            
                            Button {
                                profileViewModel.selectedDocument = .init(name: "Foto")
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
                            profileViewModel.isDeleteProfile.toggle()
                        }
                        .font(Font.system(size: 17))
                        .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    if profileViewModel.isDeleteProfile {
                        CustomAlert(title: "Hapus profil?", caption: "Jika dokumen dihapus, semua data akan hilang secara otomatis.", button1: "Hapus", button2: "Batal") {
                            Task {
                                await profileViewModel.deleteAccount(account)
                                profileViewModel.isDeleteProfile.toggle()
                            }
                        } action2: {
                            profileViewModel.isDeleteProfile.toggle()
                        }

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
            .sheet(item: $profileViewModel.selectedDocument, content: { document in
                DocumentDetailsView(document: document.name, account: account)
                    .presentationDragIndicator(.visible)
            })
            .sheet(item: $profileViewModel.uploadDocument, content: { document in
                UploadDocumentsView(document: document.name, account: account)
                    .presentationDragIndicator(.visible)
            })
            .sheet(isPresented: $profileViewModel.isUploadFile) {
                FilePicker(selectedFileURL: $profileViewModel.selectedFileURL)
            }
            .fullScreenCover(isPresented: $profileViewModel.isUploadImage) {
                ImagePicker(selectedImage: $profileViewModel.selectedImage)
            }
            .fullScreenCover(isPresented: $profileViewModel.isScanKTP, content: {
                KTPPreviewSheet(account: account)
            })
            .fullScreenCover(isPresented: $profileViewModel.isScanPaspor, content: {
                PassportPreviewSheet(account: account)
            })
            .fullScreenCover(isPresented: $profileViewModel.isScanFoto, content: {
                PhotoPreviewSheet(account: account)
            })
            .sheet(item: $selectedDocument, content: { document in
                if let account = profileViewModel.selectedAccount {
                    DocumentDetailsView(document: document.name, account: account)
                        .presentationDragIndicator(.visible)
                }
            })
            .fullScreenCover(isPresented: $isShowingEditProfile) {
                AddProfileView(account: account)
                    .onAppear {
                        profileViewModel.username = account.username
                    }
            }
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
