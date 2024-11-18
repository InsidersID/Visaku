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
                        .padding(.bottom)
                    
                    Text("Dengan itinerary, kedutaan jadi tahu kamu punya tujuan jelas dan nggak berencana tinggal lebih lama dari yang diizinkan.")
                        .font(.custom("Inter-Regular", size: 15))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Divider()
                    
                    CustomButton(text: "Selesai", textColor: .white, color: .primary5, font: "Inter-SemiBold") {
                        viewModel.isPresentingConfirmationView = false
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
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
