import SwiftUI
import UIComponentModule
import RiveRuntime

struct VisaApplicationFinishedView: View {
    var body: some View {
        ZStack {
            Color(red: 0.8, green: 0.91, blue: 0.97).ignoresSafeArea()
            
            VStack {
                Spacer()
                
//                ZStack {
                Gauge(value: 100, in: 0...100) {
                    
                } currentValueLabel: {
                    VStack {
                        Text("\(Int(100))%")
                        Text("Visa turis Italia")
                            .foregroundStyle(.black)
                            .font(.custom("Inter-SemiBold", size: 28))
                    }
                    .foregroundStyle(.blue)
                    .padding(.bottom, 50)
                }
                .gaugeStyle(VisaApplicationProgressStyle(gaugeSize: 300))
//                }
                
                Text("Kamu sudah siap!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                
                Text("Dengan itinerary, kedutaan jadi tahu kamu punya tujuan jelas dan nggak berencana tinggal lebih lama dari yang diizinkan.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Divider()
                
                CustomButton(text: "Selesai", textColor: .blue, color: .white) {
                    
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            
            RiveViewModel(fileName: "PlaneAnimation").view()
                .offset(x: 0, y: 30)
        }
    }
}

#Preview {
    VisaApplicationFinishedView()
}
