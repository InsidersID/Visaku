import SwiftUI
import UIComponentModule
import RepositoryModule
import RiveRuntime

struct AddProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject public var profileViewModel: ProfileViewModel
    private let riveViewModel: RiveViewModel
    
    @State private var isEditing: Bool = false
    
    public var account: AccountEntity?
    
    public init(account: AccountEntity? = nil) {
        self.account = account
        riveViewModel = RiveViewModel(fileName: "PlaneAddName")
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
                
                VStack {
                    riveViewModel.view()
                        .frame(height: 82)
                    
                    TextField("Masukkan namamu", text: $profileViewModel.username)
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Inter", size: 16))
                        .fontWeight(.semibold)
                        .onAppear {
                            if let account = account {
                                profileViewModel.username = account.username
                            }
                        }
                }
                .frame(height: 144, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.white)
                )
                
                CustomButton( text: isEditing ? "Ganti" : "Buat profil", textColor: .blue, color: Color(red: 0.7, green: 0.91, blue: 0.95), buttonWidth: proxy.size.width*0.24, fontSize: 12, cornerRadius: 16, paddingHorizontal: 0, paddingVertical: 0) {
                    Task {
                        if let account = account {
                            await profileViewModel.updateAccountUsername(account, newUsername: profileViewModel.username)
                        } else {
                            await profileViewModel.saveAccount()
                        }
                    }
                    profileViewModel.isAddingProfile = false
                    dismiss()
                }
                .padding()
                .frame(width: proxy.size.width, height: 144, alignment: .topTrailing)
            }
        }
    }
}

#Preview {
    AddProfileView()
        .environmentObject(ProfileViewModel())
}
