import SwiftUI

struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        TabView {
            VisaHistoryView()
                .tabItem {
                    Label("Visaku", systemImage: "pencil.line")
                }

            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle.fill")
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                }
        }
    }
}

#Preview {
    TabBarView()
}
