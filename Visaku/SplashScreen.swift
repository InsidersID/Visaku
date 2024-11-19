import SwiftUI

struct SplashScreen: View {
    @State var navigateToPrivacyPolicy: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    Color.tertiary7.ignoresSafeArea()
                    
                    Circle()
                        .frame(width: 400)
                        .foregroundStyle(Color.primary3)
                        .position(x: 119, y: 743)
                    
                    VStack {
                        Spacer()
                        
                        Image("personPlane")
                            .resizable()
                            .scaledToFit()
                            .offset(x: 0, y: 20)
                    }
                    
                    VStack {
                        Image("logoVisaku")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 99)
                        
                        Text("Visaku")
                            .font(.custom("Poppins-Bold", size: 32))
                            .foregroundStyle(Color.tertiary1)
                        
                        Spacer()
                            .frame(height: 420)
                        
                        Button {
                            navigateToPrivacyPolicy = true
                        } label: {
                            VStack {
                                Text("Sebelum mulai, yuk baca")
                                    .font(.custom("Inter-Regular", size: 14))
                                    .foregroundStyle(Color.stayBlack)
                                Text("Kebijakan Privasi Visaku")
                                    .font(.custom("Inter-Bold", size: 14))
                                    .foregroundStyle(Color.stayBlack)
                            }
                        }
                    }
                    .padding(.top, 80)
                }
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $navigateToPrivacyPolicy) {
                PrivacyPolicyView()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    SplashScreen()
}
