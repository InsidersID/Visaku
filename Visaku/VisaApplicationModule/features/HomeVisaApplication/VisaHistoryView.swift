//
//  VisaHistoryView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 18/10/24.
//

import SwiftUI
import UIComponentModule

public struct VisaHistoryView: View {
    @State var viewModel: VisaHistoryViewModel
    @State private var isShowChooseCountrySheet: Bool = false
    @State private var countryKeyword: String = ""
    @State private var isSchengenCountryChosen: Bool = false
    @State private var visaType: String = ""
    
    public init(viewModel: VisaHistoryViewModel = VisaHistoryViewModel()) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            VisaApplicationHeader(isShowChooseCountrySheet: $isShowChooseCountrySheet)
            
            if viewModel.hasData {
                ScrollView {
                    ApplicationSection(title: "Belum selesai", counter: 4)
                    ApplicationSection(title: "Riwayat", counter: 3)
                }
            } else {
                EmptyStateView()
            }
        }
        .onChange(of: !countryKeyword.isEmpty && !visaType.isEmpty) { hasBoth, previousHasBoth in
            if previousHasBoth {
                print("Requirements for the visa for \(countryKeyword) with visa type \(visaType) are:")
                let visaTypeEnum = VisaType.init(rawValue: visaType)
                if let visaType = visaTypeEnum {
                    let requirementsForItaly = VisaGeneralTouristDocumentType.getRequirements(for: visaType, in: countryKeyword)
                    
                    print("Visa Requirements for Italia:")
                    for requirement in requirementsForItaly {
                        print("- \(requirement.displayName): \(requirement.description)")
                    }
                }
                

            }
        }
        .ignoresSafeArea(edges: .all)
        .sheet(isPresented: $isShowChooseCountrySheet) {
            CountrySelectionSheetView(
                isSchengenCountryChosen: $isSchengenCountryChosen,
                countryKeyword: $countryKeyword,
                visaType: $visaType,
                onDismiss: {
                    isShowChooseCountrySheet = false
                }
            )
            .presentationDragIndicator(.visible)
            
        }
    }
}

struct ApplicationSection: View {
    let title: String
    let counter: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 20))
                .bold()
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            ForEach(0..<counter, id: \.self) { _ in
                VisaApplicationCard(visaType: "turis", country: "itali", countries: ["italy", "jerman"], visaProgressPercentage: 75, visaProgressColor: .pink) {
                    print("Card clicked")
                }
                .padding()
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            VStack {
                Image("emptyFile")
                Text("Belum ada data.")
                    .font(.system(size: 20))
                    .bold()
                Text("Yuk, ajukan visa tujuanmu di Visaku\nsekarang!")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .opacity(0.75)
            }
            .padding(.bottom, 70)
            .padding(.horizontal)
            Spacer()
        }
    }
}


#Preview {
    VisaHistoryView()
}
