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
    @State var viewModel = TabBarViewModel()
    @State var profileViewModel = ProfileViewModel()
    @StateObject var visaViewModel = VisaHistoryViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.isUnlocked {
                GeometryReader { proxy in
                    ZStack {
                        TabView(selection: $selectedTab) {
                            VisaHistoryView()
                                .tag(0)
                                .environmentObject(visaViewModel)
                            
                            ProfileView()
                                .tag(1)
                                .environment(profileViewModel)
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
                        
                        if profileViewModel.isAddingProfile {
                            Color.blackOpacity3.ignoresSafeArea()
                        }
                    }
                }
                .ignoresSafeArea()
                .navigationDestination(isPresented: $profileViewModel.navigateToMainDocuments) {
                    if let account = profileViewModel.selectedAccount {
                        MainDocumentView(name: account.username, accountId: account.id)
                            .navigationBarBackButtonHidden()
                            .environment(profileViewModel)
                    }
                }
            } else {
                idleView
                    .onTapGesture {
                        viewModel.authenticate()
                    }
            }
        }
    }
    
    private var idleView: some View {
        VStack {
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
                        
                        Text("Buka perangkat")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.stayBlack)
                    }
                    .padding(.top, 80)
                }
            }
        }
    }
}

extension TabBarView {
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        VStack {
            ZStack {
                if isActive {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.primary5)
                }
                Image(systemName: imageName)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(isActive ? Color.white : Color.primary5)
            }
            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(Color.primary5)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    TabBarView()
}
