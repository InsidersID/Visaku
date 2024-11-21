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
                    
                    SectionView(
                        title: "Informasi wali pemohon (jika pemohon dibawah 18 tahun)",
                        content: {
                            ExpandableSelection(title: "Apakah pemohon adalah anak dibawah umur 18 tahun?", options: ["Ya", "Tidak"], mode: .single, singleSelection: $viewModel.isApplicantUnder18, multipleSelection: .constant([]))
                            if viewModel.hasOtherResidence == "Ya" {
                                CustomFormField(title: "Nama depan wali", text: $viewModel.custodianFirstName)
                                CustomFormField(title: "Nama belakang wali", text: $viewModel.custodianLastName)
                                CustomFormField(title: "Alamat wali (jika berbeda dengan pemohon)", text: $viewModel.custodianAddress)
                                CustomFormField(title: "Nomor telepon wali", text: $viewModel.custodianPhoneNumber, keyboardType: .namePhonePad)
                                CustomFormField(title: "Alamat email wali", text: $viewModel.custodianEmail, keyboardType: .emailAddress)
                                CustomFormField(title: "Kebangsaan wali", text: $viewModel.custodianNationality)
                            }
                        }
                    )
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
                            CustomFormField(title: "Negara destinasi utama dan negara lainnya di Schengen", text: $viewModel.mainCountriesDestination)
                            ExpandableSelection(title: "Jumlah Anda berencana memasuki wilayah Schengen selama periode visa yang diajukan", options: ["Satu kali", "Dua kali", "Beberapa kali"], mode: .single, singleSelection: $viewModel.visaEntryCount, multipleSelection: .constant([]))
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
                            InvitationDetailsSection(viewModel: _viewModel)
                        }
                    )
                    
                    SectionView(
                        title: "Biaya perjalanan dan biaya hidup",
                        content: {
                            ExpandableSelection(title: "Pihak yang akan membayar biaya perjalanan dan biaya hidup", options: ["Oleh pemohon", "Oleh sponsor"], mode: .single, singleSelection: $viewModel.isSponsored, multipleSelection: .constant([]))
                            if viewModel.isSponsored == "Oleh sponsor" {
                                ExpandableSelection(title: "Pihak yang akan membayar biaya perjalanan dan biaya hidup", options: ["Pihak Pengundang", "Oleh pihak lain, sebutkan"], mode: .single, singleSelection: $viewModel.travelPayer, multipleSelection: .constant([]))
                                if viewModel.travelPayer == "Oleh pihak lain, sebutkan" {
                                    CustomFormField(title: "Pihak yang akan membayar biaya perjalanan dan biaya hidup lainnya", text: $viewModel.otherSponsor)
                                }
                            }
                            ExpandableSelection(title: "Bentuk biaya hidup selama di Schengen", options: ["Tunai", "Cek perjalanan", "Kartu kredit", "⁠⁠Akomodasi dibayar di muka", "⁠⁠Transportasi dibayar di muka", "Lainnya"], mode: .single, singleSelection: $viewModel.livingCostForm, multipleSelection: .constant([]))
                            if viewModel.livingCostForm == "Lainnya" {
                                CustomFormField(title: "Bentuk biaya hidup lainnya", text: $viewModel.otherLivingCostForm)
                            }
                        }
                    )
                    SectionView(
                        title: "Hanya jika pemohon adalah anggota keluarga warga negara UE, EEA, atau CH (pasangan, anak, atau tanggungan yang berpengaruh)",
                        content: {
                            CustomFormField(title: "Nama belakang keluarga yang merupakan warga negara UE, EEA, atau CH", text: $viewModel.euFamilyLastName)
                            CustomFormField(title: "Nama keluarga yang merupakan warga negara UE, EEA, atau CH", text: $viewModel.euFamilyFirstName)
                            CustomDateField(title: "Tanggal lahir keluarga yang merupakan warga negara UE, EEA, atau C", date: $viewModel.euFamilyBirthDate)
                            CustomFormField(title: "Kebangsaan keluarga yang merupakan warga negara UE, EEA, atau CH", text: $viewModel.euFamilyNationality)
                            CustomFormField(title: "Nomor dokumen perjalanan atau NIK keluarga yang merupakan warga negara UE, EEA, atau CH", text: $viewModel.euFamilyDocumentNumber)
                            ExpandableSelection(title: "Hubungan dengan keluarga yang merupakan warga negara UE, EEA, atau CH", options: ["Pasangan", "Anak", "Cucu", "Kemitraan terdaftar", "Lainnya, tolong sebutkan"], mode: .single, singleSelection: $viewModel.euFamilyRelation, multipleSelection: .constant([]))
                            
                        }
                    )
                    SectionView(
                        title: "Informasi data diri pengisi form",
                        content: {
                            ExpandableSelection(title: "Apakah orang yang mengisi form ini sama dengan pemohon", options: ["Ya", "Tidak"], mode: .single, singleSelection: $viewModel.hasOtherResidence, multipleSelection: .constant([]))
                            if viewModel.hasOtherResidence == "Tidak" {
                                CustomFormField(title: "Nama pengisi form", text: $viewModel.euFamilyLastName)
                                CustomFormField(title: "Alamat dan email pengisi form", text: $viewModel.euFamilyLastName)
                                CustomFormField(title: "Nomor telepon pengisi form", text: $viewModel.euFamilyLastName, keyboardType: .namePhonePad)
                                
                            }
                        }
                    )
                }
            }
            .padding(.bottom, 40)
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



struct InvitationDetailsSection: View {
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel

    var body: some View {
        Group {
            CustomFormField(title: "Nama belakang dan nama depan orang yang mengundang di Negara Anggota. Jika tidak berlaku, nama hotel atau akomodasi sementara di Negara Anggota", text: $viewModel.invitationDetailsName)
            CustomFormField(title: "Alamat dan alamat email dari orang yang mengundang/hotel/akomodasi sementara", text: $viewModel.invitationDetailsEmail, keyboardType: .emailAddress)
            CustomFormField(title: "Nomor Telepon dari orang yang mengundang/hotel/akomodasi sementara", text: $viewModel.invitationDetailsPhoneNumber, keyboardType: .namePhonePad)
            CustomFormField(title: "Nama dan alamat perusahaan/organisasi yang mengundang", text: $viewModel.invitationDetailsAddress)
            CustomFormField(title: "Provinsi hotel tempat Anda menginap", text: $viewModel.invitationDetailsProvince)
            CustomFormField(title: "⁠Nama belakang, nama depan, alamat, nomor telepon, dan alamat email orang yang dapat dihubungi di perusahaan/organisasi", text: $viewModel.invitationDetailsLastName)
            CustomFormField(title: "Nomor telepon perusahaan/organisasi", text: $viewModel.invitationDetailsOfficePhoneNumber, keyboardType: .namePhonePad)
        }
    }


//struct HotelDetailsSection: View {
//    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
//
//    var body: some View {
//        Group {
//            CustomFormField(title: "Nama hotel", text: $viewModel.hotelName)
//            CustomFormField(title: "Alamat hotel", text: $viewModel.hotelAddress)
//            CustomFormField(title: "Kode pos hotel tempat Anda menginap", text: $viewModel.hotelPostalCode)
//            CustomFormField(title: "Kota hotel tempat Anda menginap", text: $viewModel.hotelCity)
//            CustomFormField(title: "Provinsi hotel tempat Anda menginap", text: $viewModel.hotelProvince)
//            CustomFormField(title: "Nomor telepon hotel tempat Anda menginap", text: $viewModel.hotelPhoneNumber)
//            CustomFormField(title: "Nomor fax hotel", text: $viewModel.hotelFaxNumber)
//            CustomFormField(title: "Email hotel", text: $viewModel.hotelEmail)
//        }
//    }
//}
//
//struct PersonalInvitationSection: View {
//    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
//
//    var body: some View {
//        Group {
//            CustomFormField(title: "Nama depan orang yang mengundang", text: $viewModel.inviterFirstName)
//            CustomFormField(title: "Nama belakang orang yang mengundang", text: $viewModel.inviterLastName)
//            CustomDateField(title: "Tanggal lahir orang yang mengundang", date: $viewModel.inviterDOB)
//            CustomFormField(title: "Alamat orang yang mengundang", text: $viewModel.inviterAddress)
//            CustomFormField(title: "Kode pos alamat orang yang mengundang", text: $viewModel.inviterPostalCode)
//            CustomFormField(title: "Kota orang yang mengundang", text: $viewModel.inviterCity)
//            CustomFormField(title: "Provinsi orang yang mengundang", text: $viewModel.inviterProvince)
//            CustomFormField(title: "Nomor telepon orang yang mengundang", text: $viewModel.inviterPhoneNumber)
//            CustomFormField(title: "Nomor fax orang yang mengundang", text: $viewModel.inviterFaxNumber)
//            CustomFormField(title: "Email orang yang mengundang", text: $viewModel.inviterEmail)
//        }
//    }
//}
//
//struct CompanyInvitationSection: View {
//    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
//
//    var body: some View {
//        Group {
//            CustomFormField(title: "Nama perusahaan yang mengundang", text: $viewModel.companyName)
//            CustomFormField(title: "Alamat perusahaan yang mengundang", text: $viewModel.companyAddress)
//            CustomFormField(title: "Kode pos perusahaan yang mengundang", text: $viewModel.companyPostalCode)
//            CustomFormField(title: "Kota perusahaan yang mengundang", text: $viewModel.companyCity)
//            CustomFormField(title: "Provinsi perusahaan yang mengundang", text: $viewModel.companyProvince)
//            CustomFormField(title: "Nomor telepon perusahaan yang mengundang", text: $viewModel.companyPhoneNumber)
//            CustomFormField(title: "Nomor fax perusahaan yang mengundang", text: $viewModel.companyFaxNumber)
//            CustomFormField(title: "Email perusahaan yang mengundang", text: $viewModel.companyEmail)
//            CustomFormField(title: "Nama depan penanggung jawab", text: $viewModel.companyRepresentativeFirstName)
//            CustomFormField(title: "Nama belakang penanggung jawab", text: $viewModel.companyRepresentativeLastName)
//            CustomFormField(title: "Alamat penanggung jawab", text: $viewModel.companyRepresentativeAddress)
//            CustomFormField(title: "Nomor telepon penanggung jawab", text: $viewModel.companyRepresentativePhoneNumber)
//            CustomFormField(title: "Nomor fax penanggung jawab", text: $viewModel.companyRepresentativeFaxNumber)
//            CustomFormField(title: "Email penanggung jawab", text: $viewModel.companyRepresentativeEmail)
//        }
//    }
}

#Preview {
    ApplicationFormView()
        .environmentObject(CountryVisaApplicationViewModel())
}
