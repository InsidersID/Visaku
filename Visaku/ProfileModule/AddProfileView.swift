import SwiftUI
import UIComponentModule
import RepositoryModule
import RiveRuntime

struct AddProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ProfileViewModel.self) public var profileViewModel
    private let riveViewModel: RiveViewModel
    
    @State private var isEditing: Bool = false
    @StateObject public var account: AccountEntity
    
    public init(account: AccountEntity? = nil, isEditing: Bool = false) {
        self._account = StateObject(wrappedValue: account ?? AccountEntity(id: "", username: "", image: Data()))
        self._isEditing = State(initialValue: isEditing)
        riveViewModel = RiveViewModel(fileName: "AddProfile")
    }
    
    var body: some View {
        @Bindable var profileViewModel =  profileViewModel
        
        GeometryReader { proxy in
            ZStack {
                Color.clear.ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isEditing {
                            dismiss()
                        } else {
                            profileViewModel.isAddingProfile = false
                        }
                    }
                
                VStack {
                    riveViewModel.view()
                        .frame(height: 82)
                    
                    TextField("Masukkan namamu", text: $profileViewModel.username)
                        .multilineTextAlignment(.center)
                        .textInputAutocapitalization(.words)
                        .font(Font.custom("Inter-SemiBold", size: 16))
                        .onAppear {
                            profileViewModel.username = account.username
                        }
                        .onChange(of: profileViewModel.username) { newValue in
                            profileViewModel.username = newValue.capitalized
                        }
                }
                .frame(height: 144, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(Color("white"))
                )
                
                CustomButton( text: isEditing ? "Ganti profil" : "Buat profil", textColor: profileViewModel.username.isEmpty ? .white : .primary5, color: profileViewModel.username.isEmpty ? Color(red: 0.71, green: 0.71, blue: 0.71) : Color(red: 0.7, green: 0.91, blue: 0.95), buttonWidth: 64, buttonHeight: 30, font: "Inter-SemiBold", fontSize: 12, cornerRadius: 16, paddingHorizontal: 0, paddingVertical: 0) {
                    Task {
                        if isEditing {
                            await profileViewModel.updateAccountUsername(account, newUsername: profileViewModel.username)
                        } else {
                            await profileViewModel.saveAccount()
                            profileViewModel.isAddingProfile = false
                            profileViewModel.selectedAccount = profileViewModel.getAccountByID("")
                            profileViewModel.navigateToMainDocuments = true
                        }
                    }
                    dismiss()
                }
                .disabled(profileViewModel.username.isEmpty)
                .padding()
                .frame(width: proxy.size.width, height: 144, alignment: .topTrailing)
            }
            .frame(height: proxy.size.height, alignment: .center)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    AddProfileView()
        .environment(ProfileViewModel())
}
