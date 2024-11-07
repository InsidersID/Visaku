import SwiftUI
import UIComponentModule
import RiveRuntime

public struct OnboardingView<Destination: View>: View {
    var destination: Destination
    @State var viewModel = OnboardingViewModel()
    @State private var timeline: Int = 1
    
    public init(destination: Destination) {
        self.destination = destination
    }
    
    public var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    Color(red: 0.93, green: 0.98, blue: 0.98).ignoresSafeArea()
                    
                    OnboardingAnimation(timeline: $timeline)
                    
                    VStack {
                        CustomButton(text: "Skip", textColor: .black, color: .white, buttonWidth: proxy.size.width*0.1, buttonHeight: proxy.size.width*0.02, font: 16) {
                            viewModel.showTabBarView = true
                        }
                        .frame(width: proxy.size.width*0.8, alignment: .trailing)
                        
                        Spacer()
                        
                        Text(viewModel.getOnboardingTitle(index: timeline))
                            .font(Font.custom("Poppins-Bold", size: 32))
                        .multilineTextAlignment(.center)
                        .foregroundColor(viewModel.getOnboardingTextColor(index: timeline))
                        .padding(.bottom)
                        
                        Text(viewModel.getOnboardingCaption(index: timeline))
                            .foregroundStyle(viewModel.getOnboardingTextColor(index: timeline))
                        
                        Spacer(minLength: timeline == 1 ?
                               proxy.size.height*0.6 :
                                proxy.size.height*0.5
                        )
                        
                        if timeline == 1 || timeline == 5 {
                            CustomButton(text: timeline == 5 ? "Selesai" : "Mulai", textColor: .blue, color: .white, cornerRadius: 24) {
                                if timeline < 5 {
                                    timeline += 1
                                } else {
                                    viewModel.showTabBarView = true
                                }
                            }
                            .frame(width: proxy.size.width*0.8)
                            .shadow(color: .black.opacity(0.1), radius: 10)
                            .padding(.bottom)
                        }
                        
                    }
                    .padding()
                }
            }
            .navigationDestination(isPresented: $viewModel.showTabBarView) {
                destination
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    OnboardingView(destination: Text("Tab Bar View"))
}
