import SwiftUI
import RiveRuntime

struct OnboardingAnimation: View {
    @Binding var timeline: Int
    
    var body: some View {
        switch timeline {
        case 1:
            RiveViewModel(fileName: "onboarding", animationName: "Timeline 1").view().ignoresSafeArea()
        case 2:
            RiveViewModel(fileName: "onboarding", animationName: "Timeline 2").view().ignoresSafeArea()
                .onTapGesture {
                    timeline += 1
                }
        case 3:
            RiveViewModel(fileName: "onboarding", animationName: "Timeline 3").view().ignoresSafeArea()
                .onTapGesture {
                    timeline += 1
                }
        case 4:
            RiveViewModel(fileName: "onboarding", animationName: "Timeline 4").view().ignoresSafeArea()
                .onTapGesture {
                    timeline += 1
                }
        case 5:
            RiveViewModel(fileName: "onboarding", animationName: "Timeline 5").view().ignoresSafeArea()
                .onTapGesture {
                    timeline += 1
                }
            
        default:
            RiveViewModel(fileName: "onboarding", animationName: "Timeline 1").view().ignoresSafeArea()
        }
    }
}

#Preview {
    OnboardingAnimation(timeline: .constant(1))
}
