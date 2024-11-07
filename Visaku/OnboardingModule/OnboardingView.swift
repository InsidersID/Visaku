import SwiftUI
import RiveRuntime
import UIComponentModule

public struct OnboardingView<Destination: View>: View {
    var destination: Destination
    @State var viewModel = OnboardingViewModel()
    @State private var timeline = 1
    private let riveViewModel: RiveViewModel
    private let timelines = ["Timeline 1", "Timeline 2", "Timeline 3 new", "Timeline 4 new", "Timeline 5 new", "Timeline 6"]
    
    public init(destination: Destination) {
        self.destination = destination
        riveViewModel = RiveViewModel(fileName: "onboarding", animationName: "Timeline 1")
    }
    
    public var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    riveViewModel.view()
                        .ignoresSafeArea()
                        .onAppear {
                            playCurrentTimeline()
                        }
                        .onTapGesture {
                            if timeline > 1 && timeline < 6 {
                                timeline += 1
                                playCurrentTimeline()
                            }
                        }
                    
                    VStack {
                        CustomButton(text: "Skip", textColor: .black, color: .white, buttonWidth: proxy.size.width*0.1, buttonHeight: proxy.size.width*0.02, fontSize: 16) {
                            viewModel.showTabBarView = true
                        }
                        .frame(width: proxy.size.width*0.8, alignment: .trailing)
                        
                        Spacer()
                        
                        Text(viewModel.getOnboardingTitle(index: timeline))
//                            .font(Font.custom("Inter", size: 32))
                        .multilineTextAlignment(.center)
                        .foregroundColor(viewModel.getOnboardingTextColor(index: timeline))
                        .padding(.bottom)
                        
                        Text(viewModel.getOnboardingCaption(index: timeline))
                            .foregroundStyle(viewModel.getOnboardingTextColor(index: timeline))
                        
                        Spacer(minLength: timeline == 1 ?
                               proxy.size.height*0.6 :
                                proxy.size.height*0.5
                        )
                        
                        if timeline == 1 || timeline == 6 {
                            CustomButton(text: timeline == 6 ? "Selesai" : "Mulai", textColor: .blue, color: .white, cornerRadius: 24) {
                                if timeline < 6 {
                                    timeline += 1
                                    playCurrentTimeline()
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
    
    private func playCurrentTimeline() {
        let animationName = timelines[timeline-1]
        riveViewModel.play(animationName: animationName)
    }
}

#Preview {
    OnboardingView(destination: Text("Tab Bar View"))
}
