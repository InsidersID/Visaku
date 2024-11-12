//
//  ApplicationFormView.swift
//  Visaku
//
//  Created by Nur Nisrina on 11/11/24.
//

import SwiftUI
import UIComponentModule

struct ApplicationFormView: View {
    @State private var arrivalCountry: String? = ""
    @State private var visaPurpose: String? = ""
    @State private var additionalVisaPurpose: String? = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("applicationForm")
                    VStack {
                        Text("Informasi bepergian")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .opacity(0.8)
                        VStack {
                            ExpandableSelection(title: "Negara yang menjadi titik masuk pertama Anda ke wilayah Schengen", options: Countries.schengenCountryList, mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Tujuan utama perjalanan Anda ke wilayah Schengen", options: ["Turis/Wisata","Budaya", "Alasan Kesehatan", "Transit bandara", "Bisnis", "Olahraga", "Belajar", "Kunjungan Keluarga", "Kunjungan official", "Transit", "Tujuan lainnya"], mode: .single, singleSelection: $visaPurpose, multipleSelection: .constant([]))
                            if visaPurpose == "Tujuan lainnya" {
                                ExpandableSelection(title: "Tujuan lainnya", options: ["Undangan", "Pekerjaan pribadi", "Penelitian", "Pekerjaan maritim", "Pekerjaan hiburan", "Pekerjaan Olahraga"], mode: .single, singleSelection: $visaPurpose, multipleSelection: .constant([]))
                            }
                            ExpandableSelection(title: "Tujuan tambahan selain tujuan utama perjalanan yang perlu dicantumkan", options: ["Turis/Wisata","Budaya", "Alasan Kesehatan", "Transit bandara", "Bisnis", "Olahraga", "Belajar", "Kunjungan Keluarga", "Kunjungan official", "Transit", "Tujuan lainnya"], mode: .single, singleSelection: $additionalVisaPurpose, multipleSelection: .constant([]))
                            if additionalVisaPurpose == "Tujuan lainnyaa" {
                                ExpandableSelection(title: "Tujuan lainnya", options: ["Undangan", "Pekerjaan pribadi", "Penelitian", "Pekerjaan maritim", "Pekerjaan hiburan", "Pekerjaan Olahraga"], mode: .single, singleSelection: $additionalVisaPurpose, multipleSelection: .constant([]))
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Form aplikasi")
                    .font(.system(size: 24))
                    .bold()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .padding(10)
                        .bold()
                        .background(Circle().fill(Color.white))
                        .foregroundColor(.black)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
            }
        }
    }
}

#Preview {
    ApplicationFormView()
}
