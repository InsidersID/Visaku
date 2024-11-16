import SwiftUI
import RepositoryModule
import UIComponentModule

public struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var profileViewModel = ProfileViewModel()
    public var isSelectProfile: Bool
    
    public init(isSelectProfile: Bool = false) {
        self.isSelectProfile = isSelectProfile
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible())], spacing: 20){
                    if let accounts = profileViewModel.accounts {
                        ForEach(accounts, id: \.id) { account in
                            if isSelectProfile {
                                Button {
                                    dismiss()
                                } label: {
                                    ProfileCard(name: account.username, imageData: account.image)
                                }
                            } else {
                                Button {
                                    profileViewModel.selectedAccount = account
                                    profileViewModel.navigateToMainDocuments = true
                                } label: {
                                    ProfileCard(name: account.username, isAddProfile: false, imageData: account.image)
                                }
                            }
                        }
                    }
                    if !isSelectProfile {
                        Button {
                            profileViewModel.isAddingProfile = true
                        } label: {
                            ProfileCard(name: "Profil Baru", isAddProfile: true)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .onAppear {
                Task {
                    await profileViewModel.fetchAccount()
                }
            }
            .navigationTitle("Profil")
            .alert(isPresented: $profileViewModel.isError, error: profileViewModel.error, actions: {
                
            })
            .fullScreenCover(isPresented: $profileViewModel.isAddingProfile, content: {
                AddProfileView(isEditing: false)
                    .environment(profileViewModel)
                    .clearModalBackground()
            })
            .navigationDestination(isPresented: $profileViewModel.navigateToMainDocuments) {
                if let account = profileViewModel.selectedAccount {
                    MainDocumentView(name: account.username, accountId: account.id)
                        .navigationBarBackButtonHidden()
                        .environment(profileViewModel)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .background(.gray)
}
