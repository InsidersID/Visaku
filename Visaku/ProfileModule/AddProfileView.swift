import SwiftUI
import UIComponentModule
import RiveRuntime

struct AddProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject public var profileViewModel: ProfileViewModel
    private let riveViewModel: RiveViewModel
    
    public init() {
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
                }
                .frame(height: 144, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.white)
                )
                
                CustomButton( text: "Buat profil", textColor: .blue, color: Color(red: 0.7, green: 0.91, blue: 0.95), buttonWidth: proxy.size.width*0.16, fontSize: 12, cornerRadius: 16, paddingHorizontal: 0, paddingVertical: 0) {
                    Task {
                        await profileViewModel.saveAccount()
                    }
                    profileViewModel.isAddingProfile = false
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
