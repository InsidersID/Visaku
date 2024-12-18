import SwiftUI
import UIComponentModule
import RiveRuntime

struct VisaApplicationFinishedView: View {
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.tertiary3.ignoresSafeArea()
                
                RiveViewModel(fileName: "Clouds").view()
                    .offset(x:0, y:-90)
                    .scaleEffect(1.35)
                
                RiveViewModel(fileName: "ProgressBar").view()
                    .offset(x:0, y:-90)
                    .scaleEffect(1.35)
                
                VStack {
                    Spacer(minLength: proxy.size.height*0.6)
                    
                    Text("Kamu sudah siap!")
                        .font(.custom("Inter-SemiBold", size: 24))
                        .foregroundStyle(Color.blackOpacity5)
                        .padding(.bottom)
                    
                    Text("Semua dokumen sudah siap,\nkamu bisa print semua dokumen jika diperlukan.")
                        .frame(width: 350)
                        .font(.custom("Inter-Regular", size: 15))
                        .foregroundStyle(Color.blackOpacity3)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(width: .infinity, height: 1)
                        .foregroundStyle(Color.blackOpacity1)
                    
                    CustomButton(text: "Selesai", textColor: .white, color: .primary5, font: "Inter-SemiBold") {
                        viewModel.isPresentingConfirmationView = false
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 20)
                }
                
                RiveViewModel(fileName: "PlaneAnimation").view()
                    .offset(x: 0, y: 0)
                    .scaleEffect(0.8)
            }
        }
    }
}

#Preview {
    VisaApplicationFinishedView()
}
