//
//  VisaApplicationHeader.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 04/11/24.
//

import SwiftUI
import UIComponentModule

struct VisaApplicationHeader: View {
    @Binding var isShowChooseCountrySheet: Bool

    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Mau traveling ke \nmana?")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                    VStack {
                        Rectangle()
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 100)
                            .padding()
                    }
                }
                CustomButton(text: "Mulai pengajuan", textColor: .blue, color: .white, fontSize: 16, cornerRadius: 16, paddingVertical: 3) {
                    isShowChooseCountrySheet = true
                }
                .padding(.bottom, 10)
            }
            .padding(.top,30)
            .padding(.bottom, 6)
            .padding()
        }
        .background(.blue)
        .cornerRadius(24)
    }
}


