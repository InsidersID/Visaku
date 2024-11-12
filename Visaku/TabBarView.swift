import SwiftUI

struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            VisaHistoryView()
                .tabItem {
                    Image(systemName: "pencil.line")
                    Text("Visaku")
                }
                .tag(0)
                
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profil")
                }
                .tag(1)
        }
    }
}

#Preview {
    NavigationStack {
        TabBarView()
    }
}
