//
//  CountryEnum.swift
//  VisaApplicationModule
//
//  Created by hendra on 17/10/24.
//

import Foundation

public enum VisaGeneralTouristDocumentType: String {
    case fotokopiKartuKeluarga
    case kartuKeluargaAsli
    case fotokopiAktaKelahiranAtauSuratNikah
    case paspor
    case fotokopiPaspor
    case pasFoto
    case asuransiKesehatanPerjalanan
    case buktiPemesananAkomodasi
    case buktiPenerbangan
    case intineraryLengkap
    case rekeningKoranPribadi
    case sponsor
    case buktiKeuangan

    // Properties to determine requirements
    var requiresUpload: Bool {
        switch self {
        case .fotokopiKartuKeluarga, .fotokopiAktaKelahiranAtauSuratNikah,
             .fotokopiPaspor, .buktiPemesananAkomodasi, .buktiPenerbangan,
             .intineraryLengkap, .rekeningKoranPribadi, .sponsor, .buktiKeuangan:
            return true
        case .kartuKeluargaAsli, .paspor, .pasFoto, .asuransiKesehatanPerjalanan:
            return false
        }
    }

    var isOptionalUpload: Bool {
        return self == .sponsor
    }

    var displayName: String {
        switch self {
        case .fotokopiKartuKeluarga: return "Fotokopi Kartu Keluarga"
        case .kartuKeluargaAsli: return "Kartu Keluarga Asli"
        case .fotokopiAktaKelahiranAtauSuratNikah: return "Fotokopi Akta Kelahiran atau Surat Nikah"
        case .paspor: return "Paspor"
        case .fotokopiPaspor: return "Fotokopi Paspor"
        case .pasFoto: return "Pas Foto"
        case .asuransiKesehatanPerjalanan: return "Asuransi Kesehatan Perjalanan"
        case .buktiPemesananAkomodasi: return "Bukti Pemesanan Akomodasi"
        case .buktiPenerbangan: return "Bukti Penerbangan"
        case .intineraryLengkap: return "Itinerary Lengkap"
        case .rekeningKoranPribadi: return "Rekening Koran Pribadi"
        case .sponsor: return "Sponsor"
        case .buktiKeuangan: return "Bukti Keuangan"
        }
    }

    var description: String {
        switch self {
        case .fotokopiKartuKeluarga:
            return "Fotokopi Kartu Keluarga diperlukan untuk memverifikasi status keluarga jika bepergian dengan keluarga."
        case .kartuKeluargaAsli:
            return "Bawa Kartu Keluarga asli sebagai bukti hubungan keluarga saat melakukan perjalanan bersama keluarga."
        case .fotokopiAktaKelahiranAtauSuratNikah:
            return "Fotokopi akta kelahiran atau surat nikah diperlukan jika bepergian bersama keluarga, untuk menunjukkan bukti hubungan."
        case .paspor:
            return "Paspor harus berlaku minimal 3 bulan setelah masa tinggal di Schengen (6 bulan untuk Spanyol), memiliki 2 halaman kosong, diterbitkan dalam 10 tahun terakhir, dan ditandatangani pemegang paspor."
        case .fotokopiPaspor:
            return "Fotokopi paspor yang berisi data biometrik diperlukan sebagai dokumen pendukung identitas."
        case .pasFoto:
            return "Pas foto berukuran 35mm x 45mm dengan latar belakang putih atau warna terang, mengikuti standar ICAO, diperlukan untuk dokumen resmi."
        case .asuransiKesehatanPerjalanan:
            return "Asuransi kesehatan perjalanan minimal EUR 30.000 melindungi di wilayah Schengen, termasuk perawatan darurat dan repatriasi."
        case .buktiPemesananAkomodasi:
            return "Bukti pemesanan hotel atau tempat tinggal lainnya diperlukan untuk seluruh masa tinggal. Jika menginap dengan teman atau keluarga, pastikan menyertakan surat undangan."
        case .buktiPenerbangan:
            return "Reservasi penerbangan pergi-pulang yang dikonfirmasi memastikan rencana perjalananmu jelas dan sesuai dengan aturan visa."
        case .intineraryLengkap:
            return "Itinerary lengkap diperlukan untuk menunjukkan rencana kegiatan selama berada di Schengen, memastikan kamu memiliki jadwal perjalanan yang terstruktur."
        case .rekeningKoranPribadi:
            return "Rekening koran pribadi selama 3 bulan terakhir beserta satu fotokopinya diperlukan untuk membuktikan kemampuan finansial selama perjalanan."
        case .sponsor:
            return "Jika menggunakan sponsor, sertakan bukti keuangan sponsor dan surat sponsor sebagai jaminan dukungan finansial."
        case .buktiKeuangan:
            return "Dokumen bukti keuangan bervariasi tergantung pada status pekerjaan:\n\n- Karyawan: Surat keterangan kerja, slip gaji 3 bulan terakhir.\n- Wiraswasta: Bukti pendaftaran perusahaan, laporan pajak terakhir.\n- Pelajar: Surat keterangan dari sekolah atau universitas.\n- Tidak bekerja: Pernyataan dukungan keuangan dan bukti pendukung."
        }
    }

    static var data: [VisaGeneralTouristDocumentType] {
        return [
            .fotokopiKartuKeluarga, .kartuKeluargaAsli,
            .fotokopiAktaKelahiranAtauSuratNikah, .paspor,
            .fotokopiPaspor, .pasFoto, .asuransiKesehatanPerjalanan,
            .buktiPemesananAkomodasi, .buktiPenerbangan,
            .intineraryLengkap, .rekeningKoranPribadi,
            .sponsor, .buktiKeuangan
        ]
    }
}

public enum ItineraryGeneralTouristDocumentType: String {
    case hotelAccommodation, flightTicket, itinerary, relativeInvitationLetter
    
    static var data: [ItineraryGeneralTouristDocumentType] {
        return [.hotelAccommodation, .flightTicket, .itinerary, .relativeInvitationLetter]
    }
}

public enum FinancialGeneralTouristDocumentType: String {
    case bankStatement, sponsorFinancialStatement, sponsorshipLetter, workStatementLetter, salarySlip, companyRegistrationProof, studentRegistrationProof, selfFundedStatement, selfFundedSuitabilityProof
    
    static var data: [FinancialGeneralTouristDocumentType] {
        return [.bankStatement, .sponsorFinancialStatement, .sponsorshipLetter, .workStatementLetter, .salarySlip, .companyRegistrationProof, .studentRegistrationProof, .selfFundedStatement, .selfFundedSuitabilityProof]
    }
}

public enum PrimaryGeneralTouristDocumentType: String {
    case applicationForm
    
    static var data: [PrimaryGeneralTouristDocumentType] {
        return [.applicationForm]
    }
}

public enum ItalyTouristDocument: String {
    case bankReferenceLetter
    
    static var data: [ItalyTouristDocument] {
        return [.bankReferenceLetter]
    }
}

struct VisaType: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let value: String
    let documentRequirements: VisaDocumentRequirements
}

struct VisaDocumentRequirements: Equatable {
    let primaryDocuments: [PrimaryGeneralTouristDocumentType]
    let itineraryDocuments: [ItineraryGeneralTouristDocumentType]
    let financialDocuments: [FinancialGeneralTouristDocumentType]
    let countrySpecificDocuments: [String]
}

struct CountryData {
    let name: String
    let png: String
    let visaTypes: [VisaType]
}

public enum Country: String, Codable, CaseIterable {
    case italy
    case germany
    
    var data: CountryData {
        let flagImage = rawValue.replacingOccurrences(of: " ", with: "-") + "-flag.png"
        let visaTypes: [VisaType]
        
        // Define Visa and required documents for Italy
        switch self {
        case .italy:
            let tourismVisaDocuments = VisaDocumentRequirements(
                primaryDocuments: PrimaryGeneralTouristDocumentType.data,
                itineraryDocuments: ItineraryGeneralTouristDocumentType.data,
                financialDocuments: FinancialGeneralTouristDocumentType.data,
                countrySpecificDocuments: ItalyTouristDocument.data.map { $0.rawValue }
            )
            visaTypes = [
                VisaType(
                    name: "Tourism",
                    value: "turis",
                    documentRequirements: tourismVisaDocuments
                ),
                VisaType(
                    name: "Business",
                    value: "bisnis",
                    documentRequirements: VisaDocumentRequirements(
                        primaryDocuments: [],
                        itineraryDocuments: [],
                        financialDocuments: [],
                        countrySpecificDocuments: []
                    )
                )
            ]
        case .germany:
            let businessVisaDocuments = VisaDocumentRequirements(
                primaryDocuments: PrimaryGeneralTouristDocumentType.data,
                itineraryDocuments: ItineraryGeneralTouristDocumentType.data,
                financialDocuments: FinancialGeneralTouristDocumentType.data,
                countrySpecificDocuments: []
            )
            let tourismVisaDocuments = VisaDocumentRequirements(
                primaryDocuments: PrimaryGeneralTouristDocumentType.data,
                itineraryDocuments: ItineraryGeneralTouristDocumentType.data,
                financialDocuments: FinancialGeneralTouristDocumentType.data,
                countrySpecificDocuments: []
            )
            visaTypes = [
                VisaType(
                    name: "Business",
                    value: "bisnis",
                    documentRequirements: businessVisaDocuments
                ),
                VisaType(
                    name: "Tourism",
                    value: "turis",
                    documentRequirements: tourismVisaDocuments
                )
            ]
        }
        
        return CountryData(name: rawValue.capitalized, png: flagImage, visaTypes: visaTypes)
    }
    
    static var data: [CountryData] {
        return Country.allCases.map { $0.data }
    }
}

