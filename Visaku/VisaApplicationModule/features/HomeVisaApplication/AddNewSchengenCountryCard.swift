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
                viewModel.isAddNewSchengenCountry = true
                viewModel.countryKeyword = ""
            }, label: {
                HStack {
                    Text("Tambah negara")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                    Image(systemName: "plus")
                        .background(Circle().fill(Color.white))
                        .padding(3)
                        .foregroundStyle(.secondary)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
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
