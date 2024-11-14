import SwiftUI
import UIComponentModule
import RiveRuntime

struct VisaApplicationFinishedView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color(red: 0.8, green: 0.91, blue: 0.97).ignoresSafeArea()
                
                RiveViewModel(fileName: "ProgressBar").view()
                    .offset(x:0, y:-100)
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
