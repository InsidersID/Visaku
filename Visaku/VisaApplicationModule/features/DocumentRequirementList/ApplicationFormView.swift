//
//  ApplicationFormView.swift
//  Visaku
//
//  Created by Nur Nisrina on 11/11/24.
//

import SwiftUI
import UIComponentModule

struct ApplicationFormView: View {
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Image("applicationForm")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200)
                        .padding(.top, -40)

                    SectionView(
                        title: "Tempat tinggal di negara selain negara yang menjadi kewarganegaraannya saat ini",
                        content: {
                            ExpandableSelection(title: "Apakah Anda mempunyai tempat tinggal di negara lain selain di negara asal kewarganegaraan Anda sekarang?", options: ["Ya", "Tidak"], mode: .single, singleSelection: $viewModel.hasOtherResidence, multipleSelection: .constant([]))
                            if viewModel.hasOtherResidence == "Ya" {
                                CustomFormField(title: "Jenis izin tinggal atau dokumen setara yang dimiliki di negara tersebut", text: $viewModel.residenceType)
                                CustomFormField(title: "Nomor izin tinggal atau dokumen setara", text: $viewModel.residenceNumber)
                                CustomDateField(title: "Tanggal kadaluarsa dokumen izin tinggal", date: $viewModel.residenceExpiryDate)
                            }
                        }
                    )
                    
                    SectionView(
                        title: "Informasi bepergian",
                        content: {
                            ExpandableSelection(title: "Negara yang menjadi titik masuk pertama Anda ke wilayah Schengen", options: Countries.schengenCountryList, mode: .single, singleSelection: $viewModel.lastSchengenEntryCountry, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Tujuan utama perjalanan Anda ke wilayah Schengen", options: ["Turis/Wisata", "Budaya", "Alasan Kesehatan", "Transit bandara", "Bisnis", "Olahraga", "Belajar", "Kunjungan Keluarga", "Kunjungan official", "Transit", "Tipe lainnya"], mode: .single, singleSelection: $viewModel.mainTravelPurpose, multipleSelection: .constant([]))
                            if viewModel.mainTravelPurpose == "Tipe lainnya" {
                                ExpandableSelection(title: "Tipe lainnya", options: ["Undangan", "Pekerjaan pribadi", "Penelitian", "Pekerjaan maritim", "Pekerjaan hiburan", "Pekerjaan Olahraga"], mode: .single, singleSelection: $viewModel.mainTravelPurpose, multipleSelection: .constant([]))
                            }
                            ExpandableSelection(title: "Tujuan tambahan selain tujuan utama", options: ["Turis/Wisata", "Budaya", "Alasan Kesehatan", "Transit bandara", "Bisnis", "Olahraga", "Belajar", "Kunjungan Keluarga", "Kunjungan official", "Transit", "Tipe lainnya"], mode: .single, singleSelection: $viewModel.additionalTravelPurpose, multipleSelection: .constant([]))
                            if viewModel.additionalTravelPurpose == "Tipe lainnya" {
                                ExpandableSelection(title: "Tipe lainnya", options: ["Undangan", "Pekerjaan pribadi", "Penelitian", "Pekerjaan maritim", "Pekerjaan hiburan", "Pekerjaan Olahraga"], mode: .single, singleSelection: $viewModel.additionalTravelPurpose, multipleSelection: .constant([]))
                            }
                            ExpandableSelection(title: "Jumlah Anda berencana memasuki wilayah Schengen selama periode visa yang diajukan", options: ["Satu kali", "Dua kali", "Beberapa kali"], mode: .single, singleSelection: $viewModel.visaEntryCount, multipleSelection: .constant([]))
                            CustomFormField(title: "Jumlah hari tinggal di negara Schengen", text: $viewModel.stayDuration, keyboardType: .numbersAndPunctuation)
                            ExpandableSelection(title: "Apakah Anda telah mendapatkan visa Schengen dalam tiga tahun terakhir?", options: ["Ya", "Tidak"], mode: .single, singleSelection: $viewModel.hasPreviousVisa, multipleSelection: .constant([]))
                            if viewModel.hasPreviousVisa == "Ya" {
                                ExpandableSelection(title: "Apakah Anda mengetahui nomor atau detail sticker visa Schengen yang pernah diterbitkan untuk Anda?", options: ["Ya", "Tidak"], mode: .single, singleSelection: $viewModel.previousVisaDetails, multipleSelection: .constant([]))
                                if viewModel.previousVisaDetails == "Ya" {
                                    CustomDateField(title: "Tanggal penerbitan visa Schengen Anda dimulai", date: $viewModel.previousVisaIssueDate)
                                    CustomDateField(title: "Tanggal kadaluarsa visa Schengen Anda dimulai", date: $viewModel.previousVisaExpiryDate)
                                }
                            }
                            ExpandableSelection(title: "Apakah Anda pernah memberikan sidik jari sebelumnya untuk keperluan aplikasi visa Schengen?", options: ["Ya", "Tidak"], mode: .single, singleSelection: $viewModel.providedFingerprint, multipleSelection: .constant([]))
                            if viewModel.providedFingerprint == "Ya" {
                                CustomDateField(title: "Tanggal pengumpulan sidik jari", date: $viewModel.fingerprintDate)
                                CustomFormField(title: "Jika diketahui, berikan nomor atau detail sticker visa terkait", text: $viewModel.fingerprintVisaDetails)
                                CustomFormField(title: "Tempat ijin memasuki negara terakhir pada Schengen diterbitkan", text: $viewModel.lastSchengenEntryPlace)
                                CustomDateField(title: "Tanggal ijin tersebut diterbitkan",  date: $viewModel.lastSchengenEntryDate)
                                CustomDateField(title: "Tanggal ijin tersebut kadaluarsa", date: $viewModel.lastSchengenExitDate)
                                CustomDateField(title: "Tanggal kedatangan pada area Schengen", date: $viewModel.arrivalDate)
                                CustomDateField(title: "Tanggal kepulangan dari area Schengen", date: $viewModel.departureDate)
                            }
                        }
                    )
                    SectionView(
                        title: "Detail undangan",
                        content: {
                            ExpandableSelection(title: "Tipe undangan", options: ["Hotel", "Diundang oleh orang", "Invitation (perusahaan atau organisasi)"], mode: .single, singleSelection: $viewModel.invitationType, multipleSelection: .constant([]))
                            if viewModel.invitationType == "Hotel" {
                                HotelDetailsSection()
                            } else if viewModel.invitationType == "Diundang oleh orang" {
                                PersonalInvitationSection()
                            } else if viewModel.invitationType == "Invitation (perusahaan atau organisasi)" {
                                CompanyInvitationSection()
                            }
                        }
                    )
                    
                    SectionView(
                        title: "Biaya perjalanan dan biaya hidup",
                        content: {
                            ExpandableSelection(title: "Pihak yang akan membayar biaya perjalanan dan biaya hidup", options: ["Orang yang mengundang", "Perusahaan yang mengundang", "Lainnya"], mode: .single, singleSelection: $viewModel.travelPayer, multipleSelection: .constant([]))
                            ExpandableSelection(title: "Bentuk biaya hidup selama di Schengen", options: ["Berarti autonomy (sendiri)", "Garansi Deklarasi", "Undangan resmi", "Perjalanan prabayar", "Beasiswa"], mode: .single, singleSelection: $viewModel.livingCostForm, multipleSelection: .constant([]))
                        }
                    )
                    SectionView(
                        title: "Biaya perjalanan dan biaya hidup",
                        content: {
                            CustomFormField(title: "Nama belakang keluarga yang merupakan warga negara UE, EEA, atau CH", text: $viewModel.euFamilyLastName)
                            CustomFormField(title: "Nama keluarga yang merupakan warga negara UE, EEA, atau CH", text: $viewModel.euFamilyFirstName)
                            CustomDateField(title: "Tanggal lahir keluarga yang merupakan warga negara UE, EEA, atau C", date: $viewModel.euFamilyBirthDate)
                            CustomFormField(title: "Kebangsaan keluarga yang merupakan warga negara UE, EEA, atau CH", text: $viewModel.euFamilyNationality)
                            CustomFormField(title: "Nomor dokumen perjalanan atau NIK keluarga yang merupakan warga negara UE, EEA, atau CH", text: $viewModel.euFamilyDocumentNumber)
                            ExpandableSelection(title: "Hubungan dengan keluarga yang merupakan warga negara UE, EEA, atau CH", options: ["Pasangan", "Anak", "Cucu", "Kemitraan terdaftar", "Lainnya, tolong sebutkan"], mode: .single, singleSelection: $viewModel.euFamilyRelation, multipleSelection: .constant([]))
                            
                        }
                    )
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Form aplikasi")
                    .font(.custom("Inter-SemiBold", size: 24))
                    .bold()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.custom("Inter-SemiBold", size: 17))                        .padding(10)
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
                .font(.custom("Inter-SemiBold", size: 20))
                .bold()
                .opacity(0.8)
            content
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}

struct HotelDetailsSection: View {
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel

    var body: some View {
        Group {
            CustomFormField(title: "Nama hotel", text: $viewModel.hotelName)
            CustomFormField(title: "Alamat hotel", text: $viewModel.hotelAddress)
            CustomFormField(title: "Kode pos hotel tempat Anda menginap", text: $viewModel.hotelPostalCode)
            CustomFormField(title: "Kota hotel tempat Anda menginap", text: $viewModel.hotelCity)
            CustomFormField(title: "Provinsi hotel tempat Anda menginap", text: $viewModel.hotelProvince)
            CustomFormField(title: "Nomor telepon hotel tempat Anda menginap", text: $viewModel.hotelPhoneNumber)
            CustomFormField(title: "Nomor fax hotel", text: $viewModel.hotelFaxNumber)
            CustomFormField(title: "Email hotel", text: $viewModel.hotelEmail)
        }
    }
}

struct PersonalInvitationSection: View {
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel

    var body: some View {
        Group {
            CustomFormField(title: "Nama depan orang yang mengundang", text: $viewModel.inviterFirstName)
            CustomFormField(title: "Nama belakang orang yang mengundang", text: $viewModel.inviterLastName)
            CustomDateField(title: "Tanggal lahir orang yang mengundang", date: $viewModel.inviterDOB)
            CustomFormField(title: "Alamat orang yang mengundang", text: $viewModel.inviterAddress)
            CustomFormField(title: "Kode pos alamat orang yang mengundang", text: $viewModel.inviterPostalCode)
            CustomFormField(title: "Kota orang yang mengundang", text: $viewModel.inviterCity)
            CustomFormField(title: "Provinsi orang yang mengundang", text: $viewModel.inviterProvince)
            CustomFormField(title: "Nomor telepon orang yang mengundang", text: $viewModel.inviterPhoneNumber)
            CustomFormField(title: "Nomor fax orang yang mengundang", text: $viewModel.inviterFaxNumber)
            CustomFormField(title: "Email orang yang mengundang", text: $viewModel.inviterEmail)
        }
    }
}

struct CompanyInvitationSection: View {
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel

    var body: some View {
        Group {
            CustomFormField(title: "Nama perusahaan yang mengundang", text: $viewModel.companyName)
            CustomFormField(title: "Alamat perusahaan yang mengundang", text: $viewModel.companyAddress)
            CustomFormField(title: "Kode pos perusahaan yang mengundang", text: $viewModel.companyPostalCode)
            CustomFormField(title: "Kota perusahaan yang mengundang", text: $viewModel.companyCity)
            CustomFormField(title: "Provinsi perusahaan yang mengundang", text: $viewModel.companyProvince)
            CustomFormField(title: "Nomor telepon perusahaan yang mengundang", text: $viewModel.companyPhoneNumber)
            CustomFormField(title: "Nomor fax perusahaan yang mengundang", text: $viewModel.companyFaxNumber)
            CustomFormField(title: "Email perusahaan yang mengundang", text: $viewModel.companyEmail)
            CustomFormField(title: "Nama depan penanggung jawab", text: $viewModel.companyRepresentativeFirstName)
            CustomFormField(title: "Nama belakang penanggung jawab", text: $viewModel.companyRepresentativeLastName)
            CustomFormField(title: "Alamat penanggung jawab", text: $viewModel.companyRepresentativeAddress)
            CustomFormField(title: "Nomor telepon penanggung jawab", text: $viewModel.companyRepresentativePhoneNumber)
            CustomFormField(title: "Nomor fax penanggung jawab", text: $viewModel.companyRepresentativeFaxNumber)
            CustomFormField(title: "Email penanggung jawab", text: $viewModel.companyRepresentativeEmail)
        }
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
        .environmentObject(CountryVisaApplicationViewModel())
}
