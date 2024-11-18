//
//  JSONPreviewSheet.swift
//  Visaku
//
//  Created by Lonard Steven on 17/11/24.
//

import Foundation
import SwiftUI
import UIComponentModule

public struct JSONPreviewSheet: View {
    @StateObject var viewModel = CountryVisaApplicationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        VStack {
            Text("Tinjauan JSON")
                .font(Font.custom("Inter", size: 16))
                .padding(.vertical)
                .padding(.bottom)
            
            Spacer()
            Text("JSONmu bisa diunduh pada laman ini. Ayo pilih tombol Unduh sekarang!")
                .font(Font.custom("Inter", size: 24))
                .padding(.vertical)
                .padding(.bottom)
                .multilineTextAlignment(.center)
            Spacer()
            
            CustomButton(text: "Unduh", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                JSONDownload.shared.downloadJSON {
                    viewModel.isShowJSONDownload = false
                }
            }
            .padding()
            
            CustomButton(text: "Tutup", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                viewModel.isShowJSONDownload = false
                dismiss()
            }
            .padding()
        }
        .presentationDetents([.fraction(0.95)])
    }
}
