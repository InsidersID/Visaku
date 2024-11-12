//
//  VisaApplicationHeader.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 04/11/24.
//

import SwiftUI
import UIComponentModule

struct VisaApplicationHeader: View {
    @EnvironmentObject var viewModel: VisaHistoryViewModel

    var body: some View {
        VStack {
            VStack {
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Mau traveling \nke mana?")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 20)
                            .padding(.horizontal)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("Yuk, ajukan visamu\nsekarang.")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                CustomButton(text: "Mulai pengajuan", textColor: Color(.primary5), color: .white, fontSize: 16, cornerRadius: 16, paddingVertical: 12) {
                    viewModel.isShowChooseCountrySheet = true
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
            }
            .padding(.top, 60)
            .padding(.bottom, 50)
            .padding(.horizontal)
            .background(
                Image("homeVisaApplication")
                    .resizable()
                    .scaledToFill()
                    .padding(.top, 20)
                    .padding(.trailing, 25)
                )
        }
        .background(Color(.primary4))
        .cornerRadius(24)

    }
}

#Preview {
    VisaApplicationHeader()
        .environmentObject(VisaHistoryViewModel())
}

