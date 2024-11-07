import SwiftUI
import UIComponentModule

struct AddProfileView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ProfileViewModel.self) public var profileViewModel
    var planeAddName: Content
    
    init (planeAddName: Content = Text(" ")) {
        self.planeAddName = planeAddName
    }
    
    var body: some View {
        @Bindable var profileViewModel =  profileViewModel
        
        GeometryReader { proxy in
            ZStack {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
                
                VStack {
                    planeAddName
                    
                    TextField("Masukkan namamu", text: $profileViewModel.username)
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Inter", size: 16))
                        .fontWeight(.semibold)
                }
                .frame(height: proxy.size.height*0.19, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.white)
                )
                
                CustomButton( text: "Buat profil", textColor: .blue, color: Color(red: 0.7, green: 0.91, blue: 0.95), buttonWidth: proxy.size.width*0.16, font: 12, cornerRadius: 16, paddingHorizontal: 0, paddingVertical: 0) {
                    Task {
                        await profileViewModel.saveAccount()
                    }
                    profileViewModel.isAddingProfile = false
                }
                .padding()
                .frame(width: proxy.size.width, height: proxy.size.height*0.19, alignment: .topTrailing)
            }
        }
    }
}

#Preview {
    AddProfileView()
        .environment(ProfileViewModel())
}
