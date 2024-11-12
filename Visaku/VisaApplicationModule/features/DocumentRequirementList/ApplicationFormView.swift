//
//  ApplicationFormView.swift
//  Visaku
//
//  Created by Nur Nisrina on 11/11/24.
//

import SwiftUI
import UIComponentModule

struct ApplicationFormView: View {
    @State private var hasOtherResidence: String? = ""
    @State private var residenceType: String = ""
    @State private var residenceNumber: String = ""
    @State private var residenceExpiryDate: Date? = nil
    
    @State private var mainTravelPurpose: String? = ""
    @State private var additionalTravelPurpose: String? = ""
    
    @State private var visaEntryCount: String? = ""
    @State private var stayDuration: String = ""
    
    @State private var hasPreviousVisa: String? = ""
    @State private var previousVisaDetails: String? = ""
    @State private var previousVisaIssueDate: Date? = nil
    @State private var previousVisaExpiryDate: Date? = nil
    
    @State private var providedFingerprint: String? = ""
    @State private var fingerprintDate: Date? = nil
    @State private var fingerprintVisaDetails: String = ""
    @State private var lastSchengenEntryPlace: String = ""
    
    @State private var lastSchengenEntryCountry: String? = ""
    @State private var lastSchengenEntryDate: Date? = nil
    @State private var lastSchengenExitDate: Date? = nil
    @State private var arrivalDate: Date? = nil
    @State private var departureDate: Date? = nil
    
    @State private var travelPayer: String? = ""
    @State private var livingCostForm: String? = ""
    
    @State private var euFamilyLastName: String = ""
    @State private var euFamilyFirstName: String = ""
    @State private var euFamilyBirthDate: Date? = nil
    @State private var euFamilyNationality: String = ""
    @State private var euFamilyDocumentNumber: String = ""
    @State private var euFamilyRelation: String? = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("applicationForm")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200)
                        .padding()

                    SectionView(
                        title: "Tempat tinggal di negara selain negara yang menjadi kewarganegaraannya saat ini",
                        content: {
                            ExpandableSelection(title: "Apakah Anda mempunyai tempat tinggal di negara lain selain di negara asal kewarganegaraan Anda sekarang?", options: ["Yes", "No"], mode: .single, singleSelection: $hasOtherResidence, multipleSelection: .constant([]))
                            if hasOtherResidence == "Yes" {
                                CustomFormField(title: "Jenis izin tinggal atau dokumen setara yang dimiliki di negara tersebut", text: $residenceType)
                                CustomFormField(title: "Nomor izin tinggal atau dokumen setara", text: $residenceNumber)
                                
                                DatePicker("Tanggal kadaluarsa dokumen izin tinggal", selection: Binding($residenceExpiryDate, replacingNilWith: Date()), displayedComponents: .date)
                            }
                        }
                    )

                    SectionView(
                        title: "Informasi bepergian",
                        content: {
//                            ExpandableSelection(title: "Negara yang menjadi titik masuk pertama Anda ke wilayah Schengen", options: Countries.schengenCountryList, mode: .single, singleSelection: $lastSchengenEntryCountry, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Tujuan utama perjalanan Anda ke wilayah Schengen", options: ["Turis/Wisata", "Budaya", "Alasan Kesehatan", "Transit bandara", "Bisnis", "Olahraga", "Belajar", "Kunjungan Keluarga", "Kunjungan official", "Transit", "Tipe lainnya"], mode: .single, singleSelection: $mainTravelPurpose, multipleSelection: .constant([]))
                            if mainTravelPurpose == "Tipe lainnya" {
                                ExpandableSelection(title: "Tipe lainnya", options: ["Undangan", "Pekerjaan pribadi", "Penelitian", "Pekerjaan maritim", "Pekerjaan hiburan", "Pekerjaan Olahraga"], mode: .single, singleSelection: $mainTravelPurpose, multipleSelection: .constant([]))
                            }
                            ExpandableSelection(title: "Tujuan tambahan selain tujuan utama", options: ["Turis/Wisata", "Budaya", "Alasan Kesehatan", "Transit bandara", "Bisnis", "Olahraga", "Belajar", "Kunjungan Keluarga", "Kunjungan official", "Transit", "Tipe lainnya"], mode: .single, singleSelection: $additionalTravelPurpose, multipleSelection: .constant([]))
                            if additionalTravelPurpose == "Tipe lainnya" {
                                ExpandableSelection(title: "Tipe lainnya", options: ["Undangan", "Pekerjaan pribadi", "Penelitian", "Pekerjaan maritim", "Pekerjaan hiburan", "Pekerjaan Olahraga"], mode: .single, singleSelection: $additionalTravelPurpose, multipleSelection: .constant([]))
                            }
                            ExpandableSelection(title: "Jumlah Anda berencana memasuki wilayah Schengen selama periode visa yang diajukan", options: ["Satu kali", "Dua kali", "Beberapa kali"], mode: .single, singleSelection: $visaEntryCount, multipleSelection: .constant([]))
                            CustomFormField(title: "Jumlah hari tinggal di negara Schengen", text: $stayDuration, keyboardType: .numbersAndPunctuation)
                            ExpandableSelection(title: "Apakah Anda telah mendapatkan visa Schengen dalam tiga tahun terakhir?", options: ["Yes", "No"], mode: .single, singleSelection: $hasPreviousVisa, multipleSelection: .constant([]))
                            if hasPreviousVisa == "Yes" {
                                ExpandableSelection(title: "Apakah Anda mengetahui nomor atau detail sticker visa Schengen yang pernah diterbitkan untuk Anda?", options: ["Yes", "No"], mode: .single, singleSelection: $previousVisaDetails, multipleSelection: .constant([]))
                                if previousVisaDetails == "Yes" {
                                    DatePicker("Tanggal penerbitan visa Schengen Anda dimulai", selection: Binding($previousVisaIssueDate, replacingNilWith: Date()), displayedComponents: .date)
                                    DatePicker("Tanggal kadaluarsa visa Schengen Anda dimulai", selection: Binding($previousVisaExpiryDate, replacingNilWith: Date()), displayedComponents: .date)
                                }
                            }
                            ExpandableSelection(title: "Apakah Anda pernah memberikan sidik jari sebelumnya untuk keperluan aplikasi visa Schengen?", options: ["Yes", "No"], mode: .single, singleSelection: $providedFingerprint, multipleSelection: .constant([]))
                            if providedFingerprint == "Yes" {
                                DatePicker("Tanggal pengumpulan sidik jari", selection: Binding($fingerprintDate, replacingNilWith: Date()), displayedComponents: .date)
                                CustomFormField(title: "Jika diketahui, berikan nomor atau detail sticker visa terkait", text: $fingerprintVisaDetails)
                                CustomFormField(title: "Tempat ijin memasuki negara terakhir pada Schengen diterbitkan", text: $lastSchengenEntryPlace)
                                DatePicker("Tanggal ijin tersebut diterbitkan", selection: Binding($lastSchengenEntryDate, replacingNilWith: Date()), displayedComponents: .date)
                                DatePicker("Tanggal ijin tersebut kadaluarsa", selection: Binding($lastSchengenExitDate, replacingNilWith: Date()), displayedComponents: .date)
                                DatePicker("Tanggal kedatangan pada area Schengen", selection: Binding($arrivalDate, replacingNilWith: Date()), displayedComponents: .date)
                                DatePicker("Tanggal kepulangan dari area Schengen", selection: Binding($departureDate, replacingNilWith: Date()), displayedComponents: .date)
                            }
                        }
                    )
                    
                    SectionView(
                        title: "Biaya perjalanan dan biaya hidup",
                        content: {
                            ExpandableSelection(title: "Pihak yang akan membayar biaya perjalanan dan biaya hidup", options: ["Orang yang mengundang", "Perusahaan yang mengundang", "Lainnya"], mode: .single, singleSelection: $travelPayer, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Bentuk biaya hidup selama di Schengen", options: ["Berarti autonomy (sendiri)", "Garansi Deklarasi", "Undangan resmi", "Perjalanan prabayar", "Beasiswa"], mode: .single, singleSelection: $livingCostForm, multipleSelection: .constant([]))
                        }
                    )
                    SectionView(
                        title: "Biaya perjalanan dan biaya hidup",
                        content: {
                            CustomFormField(title: "Nama belakang keluarga yang merupakan warga negara UE, EEA, atau CH", text: $euFamilyLastName)
                            CustomFormField(title: "Nama keluarga yang merupakan warga negara UE, EEA, atau CH", text: $euFamilyFirstName)
                            DatePicker("Tanggal lahir keluarga yang merupakan warga negara UE, EEA, atau C", selection: Binding($euFamilyBirthDate, replacingNilWith: Date()), displayedComponents: .date)
                            CustomFormField(title: "Kebangsaan keluarga yang merupakan warga negara UE, EEA, atau CH", text: $euFamilyNationality)
                            CustomFormField(title: "Nomor dokumen perjalanan atau NIK keluarga yang merupakan warga negara UE, EEA, atau CH", text: $euFamilyDocumentNumber)
                            ExpandableSelection(title: "Hubungan dengan keluarga yang merupakan warga negara UE, EEA, atau CH", options: ["Pasangan", "Anak", "Cucu", "Kemitraan terdaftar", "Lainnya, tolong sebutkan"], mode: .single, singleSelection: $euFamilyRelation, multipleSelection: .constant([]))
                            
                        }
                    )
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
                        .background(Circle().fill(Color.white))
                        .foregroundColor(.black)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
            }
        }
    }
}

struct SectionView<Content: View>: View {
    var title: String
    var content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 20))
                .bold()
                .opacity(0.8)
            content
        }
        .padding()
    }
}

extension Binding {
    init(_ source: Binding<Value?>, replacingNilWith placeholder: Value) {
        self.init(
            get: { source.wrappedValue ?? placeholder },
            set: { source.wrappedValue = $0 }
        )
    }
}

#Preview {
    ApplicationFormView()
}
