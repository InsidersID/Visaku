//
//  DocumentEnum.swift
//  Visaku
//
//  Created by Lonard Steven on 12/11/24.
//

public enum AllDocumentType: String, Identifiable {
    case personalPhoto
    case ktp
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
    
    public var id: String {
        return self.rawValue
    }

}
