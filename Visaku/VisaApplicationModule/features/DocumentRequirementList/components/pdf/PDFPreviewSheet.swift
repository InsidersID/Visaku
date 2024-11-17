//
//  PDFPreviewSheet.swift
//  Visaku
//
//  Created by Lonard Steven on 17/11/24.
//

import SwiftUI
import Foundation
import UIComponentModule

public struct PDFPreviewSheet: View {
    @StateObject var viewModel = CountryVisaApplicationViewModel()
    
    public var body: some View {
        VStack {
            Text("Tinjauan PDF")
                .font(Font.custom("Inter", size: 16))
                .padding(.vertical)
                .padding(.bottom)
            
            if let pdfURL = Bundle.main.url(forResource: "visa_form", withExtension: "pdf") {
                PDFPreviewView(pdfURL: pdfURL)
                    .frame(height: 800)
                    .background(.gray.opacity(0.3))
                    .cornerRadius(16)
                    .edgesIgnoringSafeArea(.all)
                    .padding()
                
                CustomButton(text: "Unduh PDF", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    PDFDownload.shared.downloadPDF()
                    viewModel.isShowPreviewVisaApplicationForm = false
                }
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray)
                    .frame(height: 200)
                    .overlay {
                        VStack {
                            Image(systemName: "document.badge.ellipsis")
                                .resizable()
                                .frame(width: 96, height: 64)
                                .foregroundStyle(.white)
                                .padding()
                                
                            Text("Sepertinya file PDFmu tidak ditemukan \n atau gagal diakses.")
                                .font(.custom("Inter", size: 16))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    .padding()
                
                CustomButton(text: "Tutup", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) { 
                    viewModel.isShowPreviewVisaApplicationForm = false
                }
            }
        }
        .presentationDetents([.fraction(0.9)])
    }
}
