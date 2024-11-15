import SwiftUI
import RepositoryModule
import UIComponentModule

struct Document: Identifiable, Equatable {
    let id = UUID()
    let name: String
}

public struct MainDocumentView: View {
    public var name: String
    @Environment(\.dismiss) private var dismiss
    @Environment(ProfileViewModel.self) var profileViewModel
    @State private var scanResult: UIImage?
    @State private var isShowingEditProfile = false
    
    public var accountId: String
    
    public init(name: String, accountId: String) {
        self.name = name
        self.accountId = accountId
    }
    
    private var account: AccountEntity {
        profileViewModel.accounts?.first(where: { $0.id == accountId }) ?? AccountEntity(id: accountId, username: "", image: Data())
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
                            Button(action: {
                                profileViewModel.selectedDocument = .init(name: "Foto")
                            }){
                                if let updatedAccount = profileViewModel.getAccountByID(account.id),
                                   let accountImage = UIImage(data: updatedAccount.image) {
                                    Image(uiImage: accountImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 86, height: 86)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(.white, lineWidth: 2))
                                } else {
                                    Circle()
                                        .foregroundStyle(Color(red: 0.85, green: 0.85, blue: 0.85))
                                        .frame(width: 86, height: 86)
                                }

                            }
                            
                            Button(action: {
                                isShowingEditProfile = true
                            }) {
                                HStack {
                                    if let updatedAccount = profileViewModel.getAccountByID(account.id) {
                                        Text(updatedAccount.username)
                                            .font(Font.custom("Inter", size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                        
                                        Image(systemName: "pencil")
                                    }
                                }
                            }

                        }
                        
                        Spacer()
                        
                        VStack(spacing: proxy.size.width*0.03) {
                            HStack(spacing: proxy.size.width*0.03) {
                                Button {
                                    profileViewModel.selectedDocument = .init(name: "KTP")
                                    
                                } label: {
                                    DocumentCard(height: proxy.size.height*102/798, document: "KTP", status: account.identityCard == nil ? .undone : .done)
                                }
                                
                                Button {
                                    profileViewModel.selectedDocument = .init(name: "Paspor")
                                } label: {
                                    DocumentCard(height: proxy.size.height*102/798, document: "Paspor", status: account.passport == nil ? .undone : .done)
                                }
                            }
                            
                            Button {
                                profileViewModel.selectedDocument = .init(name: "Foto")
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
            .onReceive(NotificationCenter.default.publisher(for: .accountImageUpdated)) { notification in
                Task {
                    if let updatedAccountID = notification.object as? String, updatedAccountID == account.id {
                        await profileViewModel.fetchAccountByID(account.id)
                    }
                }
            }
            .sheet(item: $profileViewModel.selectedDocument, content: { document in
                DocumentDetailsView(document: document.name, account: account)
                    .presentationDragIndicator(.visible)
            })
            .sheet(item: $profileViewModel.uploadDocument, content: { document in
                UploadDocumentsView(document: document.name, account: account)
                    .presentationDragIndicator(.visible)
            })
            .sheet(isPresented: $profileViewModel.isUploadImageForKTP) {
                KTPPreviewSheet(account: account, origin: .imagePicker)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $profileViewModel.isUploadImageForPassport, content: {
                PassportPreviewSheet(account: account, origin: .imagePicker)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            })
            .sheet(isPresented: $profileViewModel.isUploadImageForFoto, content: {
                PhotoPreviewSheet(account: account, origin: .imagePicker)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            })
            .sheet(isPresented: $profileViewModel.isScanPaspor, content: {
                PassportPreviewSheet(account: account, origin: .cameraScanner)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            })
            .sheet(isPresented: $profileViewModel.isScanKTP, content: {
                KTPPreviewSheet(account: account, origin: .cameraScanner, profileViewModel: profileViewModel)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                    .environment(profileViewModel)
            })
            .sheet(isPresented: $profileViewModel.isScanPaspor, content: {
                PassportPreviewSheet(account: account, origin: .cameraScanner)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            })
            .sheet(isPresented: $profileViewModel.isScanFoto, content: {
                PhotoPreviewSheet(account: account, origin: .cameraScanner)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            })
            .fullScreenCover(isPresented: $isShowingEditProfile) {
                AddProfileView(account: account, isEditing: true)
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
        }
    }
}

extension Notification.Name {
    static let accountImageUpdated = Notification.Name("accountImageUpdated")
}

//#Preview {
//    MainDocumentView(name: "Iqbal", accountId: AccountEntity(id: "1", username: "IqbalGanteng", image: Data()))
//        .environment(ProfileViewModel())
//}
