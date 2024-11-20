import SwiftUI

struct SplashScreen: View {
    @State var navigateToPrivacyPolicy: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    Color.tertiary7.ignoresSafeArea()
                    VStack {
                        Spacer()
                            .frame(height: proxy.size.height * 0.2 )
                        Image("logoVisaku")
                            .resizable()
                            .scaledToFit()
                            .frame(height: proxy.size.height * 0.11)
                        Text("Visaku")
                            .font(.custom("Poppins-Bold", size: 32))
                            .foregroundStyle(Color.tertiary1)
                        ZStack {
                            Circle()
                                .frame(width: proxy.size.height * 0.5)
                                .foregroundStyle(Color.primary3)
                                .offset(x: proxy.size.width * -0.2, y: proxy.size.height * 0.16)
                            Image("personPlane")
                                .resizable()
                                .scaledToFit()
                                .ignoresSafeArea()
                                .offset(x: 0, y: proxy.size.height * 0.02)
                            VStack {
                                Text("Sebelum mulai, yuk baca")
                                    .font(.custom("Inter-Regular", size: 14))
                                    .foregroundStyle(Color.stayBlack)
                                Text("Kebijakan Privasi Visaku")
                                    .font(.custom("Inter-Bold", size: 14))
                                    .foregroundStyle(Color.stayBlack)
                            }.offset(x: 0, y: proxy.size.height * 0.18)
                        }
                        Spacer()
                    }
                }
                .onTapGesture {
                    self.navigateToPrivacyPolicy = true
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
