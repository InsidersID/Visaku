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
    @State var yesNoSelection: String? = ""
    @State var numOfVisit: String? = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("applicationForm")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200)
                        .padding()
                    VStack {
                        Text("Izin tinggal lain")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                        .opacity(0.8)
                        VStack {
                            ExpandableSelection(title: "Apakah Anda mempunyai tempat tinggal di negara lain selain di negara asal kewarganegaraan Anda sekarang?", options: ["Yes", "No"], mode: .single, singleSelection: $yesNoSelection, multipleSelection: .constant([]))
                            if yesNoSelection == "Yes" {
                                ExpandableSelection(title: "Jenis izin tinggal atau dokumen setara yang dimiliki di negara tersebut", options: [], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                                ExpandableSelection(title: "Nomor izin tinggal atau dokumen setara", options: [], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                                ExpandableSelection(title: "Tanggal kadaluarsa dokumen izin tinggal setara berlaku", options: [], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                            }
                        }
                        .padding(.vertical)
                    }
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
                            ExpandableSelection(title: "Jumlah Anda berencana memasuki wilayah Schengen selama periode visa yang diajukan", options: ["Satu kali", "Dua kali", "Beberapa kali"], mode: .single, singleSelection: $numOfVisit, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Jumlah hari tinggal di negara Schengen", options: ["Satu kali", "Dua kali", "Beberapa kali"], mode: .single, singleSelection: $numOfVisit, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Apakah Anda telah mendapatkan visa schengen dalam tiga bulan terakhir?", options: ["Yes", "No"], mode: .single, singleSelection: $yesNoSelection, multipleSelection: .constant([]))
                            if yesNoSelection == "Yes" {
                                ExpandableSelection(title: "Apakah Anda mengetahui nomor atau detail sticker visa Schengen yang pernah diterbitkan untuk Anda?", options: ["Yes", "No"], mode: .single, singleSelection: $yesNoSelection, multipleSelection: .constant([]))
                                if yesNoSelection == "Yes" {
                                    //TODO: calendar sheet mulai
                                    //TODO: calendar sheet kadaluarsa

                                }
                            }
                            ExpandableSelection(title: "Apakah Anda pernah memberikan sidik jari sebelumnya untuk keperluan aplikasi visa Schengen", options: ["Yes", "No"], mode: .single, singleSelection: $yesNoSelection, multipleSelection: .constant([]))
                            if yesNoSelection == "Yes" {
                                //TODO: calendar pengumpulan sidik jari tersebut dilakukan
                                //TODO: form nomor atau detail sticker visa terkait dengan pengumpulan sidik jari tersebut

                            }
                        }
                        .padding(.vertical)
                    }
                    VStack {
                        Text("Biaya Perjalanan dan biaya hidup pemohon")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .opacity(0.8)
                        VStack {
                            ExpandableSelection(title: "Pihak yang akan membayar biaya perjalanan dan biaya hidup selama berpergian diri sendiri", options: ["Orang yang mengundang", "Perusahaan yang mengundang", "Lainnya"], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Bentuk biaya hidup selama di Schengen", options: ["Berarti autonomy (sendiri)", "Garansi Deklarasi", "Undangan resmi", "Perjalanan prabayar", "Beasiswa"], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                        }
                        .padding(.vertical)
                    }
                    VStack {
                        Text("Hanya jika pemohon adalah anggota keluarga warga negara UE, EEA, atau CH (pasangan, anak, atau tanggungan yang berpengaruh)")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .opacity(0.8)
                        VStack {
                            ExpandableSelection(title: "Nama belakang keluarga yang merupakan warga negara UE, EEA, atau CH", options: ["Orang yang mengundang", "Perusahaan yang mengundang", "Lainnya"], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Nama keluarga yang merupakan warga negara UE, EEA, atau CH", options: ["Berarti autonomy (sendiri)", "Garansi Deklarasi", "Undangan resmi", "Perjalanan prabayar", "Beasiswa"], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Tanggal lahir keluarga yang merupakan warga negara UE, EEA, atau CH", options: ["Orang yang mengundang", "Perusahaan yang mengundang", "Lainnya"], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Kebangsaan keluarga yang merupakan warga negara UE, EEA, atau CH", options: ["Berarti autonomy (sendiri)", "Garansi Deklarasi", "Undangan resmi", "Perjalanan prabayar", "Beasiswa"], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Nomor dokumen perjalanan atau NIK keluarga yang merupakan warga negara UE, EEA, atau CH", options: ["Orang yang mengundang", "Perusahaan yang mengundang", "Lainnya"], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Hubungan dengan keluarga yang merupakan warga negara UE, EEA, atau CH", options: ["Pasangan", "Anak", "Cucu", "Kemitraan terdaftar", "Lainnya, tolong sebutkan"], mode: .single, singleSelection: $arrivalCountry, multipleSelection: .constant([]))
                        }
                        .padding(.vertical)
                    }
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
