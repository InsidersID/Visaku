//
//  ContentView.swift
//  CustomTabbarSwiftUI
//
//  Created by Zeeshan Suleman on 03/03/2023.
//

import SwiftUI

enum TabbedItems: Int, CaseIterable{
    case visaku = 0
    case profile
    
    var title: String{
        switch self {
        case .visaku:
            return "Visaku"
        case .profile:
            return "Profile"
        }
    }
    
    var iconName: String{
        switch self {
        case .visaku:
            return "pencil.line"
        case .profile:
            return "person.fill"
        }
    }
}

struct TabBarView: View {
    
    @State var selectedTab = 0
    
    init() {
        UITabBar.appearance().barTintColor = .white
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                TabView(selection: $selectedTab) {
                    VisaHistoryView()
                        .tag(0)
                    
                    ProfileView()
                        .tag(1)
                }
                
                ZStack{
                    HStack(spacing: proxy.size.width*0.4){
                        ForEach((TabbedItems.allCases), id: \.self){ item in
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                                .onTapGesture {
                                    selectedTab = item.rawValue
                                }
                        }
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottom)
            }
        }
        .ignoresSafeArea()
    }
}

extension TabBarView {
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        VStack {
            ZStack {
                if isActive {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.blue)
                }
                Image(systemName: imageName)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(isActive ? .white : .blue)
            }
            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(.blue)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    TabBarView()
}
