import SwiftUI

struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            VisaHistoryView()
                .tabItem {
                    if selectedTab == 0 {
                        Image("visaku_tab_logo")
                    } else {
                        Image(systemName: "pencil.line")
                            .imageScale(.small)
                    }
                    Text("Visaku")
                }
                .tag(0)
                
            ProfileView()
                .tabItem {
                    if selectedTab == 1 {
                        Image("profil_tab_logo")
                    } else {
                        Image(systemName: "person")
                            .imageScale(.small)
                    }
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
