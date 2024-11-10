import SwiftUI
import RepositoryModule
import UIComponentModule

public struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject public var profileViewModel: ProfileViewModel = ProfileViewModel()
    public var isSelectProfile: Bool
    
    public init(isSelectProfile: Bool = false) {
        self.isSelectProfile = isSelectProfile
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    if let accounts = profileViewModel.accounts {
                        ForEach(accounts) { account in
                            if isSelectProfile {
                                Button {
                                    dismiss()
                                } label: {
                                    ProfileCard(name: account.username, imageData: account.image)
                                }
                            } else {
                                NavigationLink {
                                    MainDocumentView(name: account.username, accountId: account.id)
                                        .navigationBarBackButtonHidden()
                                        .environmentObject(profileViewModel)
                                } label: {
                                    ProfileCard(name: account.username, isAddProfile: false)
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
            }
            .onAppear {
                Task {
                    await profileViewModel.fetchAccount()
                }
            }
            .padding(.horizontal)
            .navigationTitle("Profil")
            .alert(isPresented: $profileViewModel.isError, error: profileViewModel.error, actions: { })
            .fullScreenCover(isPresented: $profileViewModel.isAddingProfile) {
                AddProfileView(planeAddName: planeAddName)
                    .environmentObject(profileViewModel)
                    .clearModalBackground()
            }
        }
    }
}

#Preview {
    ProfileView()
        .background(.gray)
}
