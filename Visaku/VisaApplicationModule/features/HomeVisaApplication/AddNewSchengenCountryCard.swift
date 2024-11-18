//
//  AddNewSchengenCountryCard.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 07/11/24.
//

import SwiftUI
import UIComponentModule

struct AddNewSchengenCountryCard: View {
    @EnvironmentObject var viewModel: VisaHistoryViewModel
    @State var isAddNewSchengenCountry: Bool = false
    
    var body: some View {
        CardContainer(cornerRadius: 18) {
            Button(action: {
                isAddNewSchengenCountry = true
            }, label: {
                HStack {
                    Text("Tambah negara")
                        .font(.custom("Inter-Regular", size: 16))
                        .foregroundStyle(Color.blackOpacity3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                    Image(systemName: "plus.circle")
                        .foregroundStyle(Color.blackOpacity3)
                }
            })
        }
        .foregroundStyle(.secondary)
        .sheet(isPresented: $isAddNewSchengenCountry) {
            SchengenCountrySelectionSheetView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    AddNewSchengenCountryCard()
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .environmentObject(VisaHistoryViewModel())
}
