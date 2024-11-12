import SwiftUI

struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            VisaHistoryView()
                .tabItem {
                    Label("Visaku", systemImage: "pencil.line")
                }
                .tag(0)
                
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle.fill")
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                }
                .tag(1)
        }
    }
}

#Preview {
    TabBarView()
}
