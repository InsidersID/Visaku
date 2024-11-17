import SwiftUI
import UIComponentModule
import RepositoryModule

public struct DocumentDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(ProfileViewModel.self) var profileViewModel
    public var document: String
    @State private var isSeeDetails: Bool = false
    @StateObject public var account: AccountEntity
    @State public var status: DocumentStatus
    @State private var passportDetailsIndex = 1
    
    public init (document: String, account: AccountEntity? = nil, status: DocumentStatus = .undone) {
        self.document = document
        self._account = StateObject(wrappedValue: account ?? AccountEntity(id: "", username: "", image: Data()))
        self.status = status
    }
    
    public var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Text(document)
                        .font(Font.custom("Inter-SemiBold", size: 16))
                        .padding(.top)
                        .padding(.vertical)
                    
                    if !isSeeDetails {
                        VStack {
                            HStack {
                                Button {
                                    profileViewModel.uploadDocument = .init(name: document)
                                    dismiss()
                                } label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: 22)
                                            .foregroundStyle(Color.primary5)
                                        
                                        Image(systemName: "square.and.arrow.up")
                                            .resizable()
                                            .frame(width: 11, height: 13)
                                            .foregroundStyle(.white)
                                            .fontWeight(.bold)
                                            .offset(x: 0, y: -1)
                                    }
                                    
                                    Text("Upload dari device")
                                        .font(Font.custom("Inter-Regular", size: 16))
                                        .foregroundStyle(.black)
                                }
                                
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            
                            HStack {
                                Button {
                                    dismiss()
                                    switch document {
                                    case "KTP":
                                        profileViewModel.isScanKTP = true
                                        
                                    case "Paspor":
                                        profileViewModel.isScanPaspor = true
                                        
                                    case "Foto":
                                        profileViewModel.isScanFoto = true
                                    default:
                                        dismiss()
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: 22)
                                            .foregroundStyle(Color.primary5)
                                        
                                        Image(systemName: "camera")
                                            .resizable()
                                            .frame(width: 14, height: 12)
                                            .foregroundStyle(.white)
                                            .fontWeight(.bold)
                                            .offset(x: 0, y: -1)
                                    }
                                    
                                    Text(document == "Foto" ? "Ambil foto" : "Scan dokumen")
                                        .font(Font.custom("Inter-Regular", size: 16))
                                        .foregroundStyle(.black)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            
                            HStack {
                                Button {
                                    isSeeDetails = true
                                } label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: 22)
                                            .foregroundStyle(Color.primary5)
                                        
                                        Image(systemName: "eye")
                                            .resizable()
                                            .frame(width: 14, height: 11)
                                            .foregroundStyle(.white)
                                            .fontWeight(.bold)
                                    }
                                    
                                    Text("Lihat ketentuan")
                                        .font(Font.custom("Inter-Regular", size: 16))
                                        .foregroundStyle(.black)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        
                    } else {
                        VStack {
                            Image(document == "Foto" ? "photo_checker" : "documents_folder")
                                .resizable()
                                .scaledToFit()
                                .padding()
                            
                            Text(document != "Paspor" ? "Yuk, ambil foto terbaikmu untuk pengajuan visa. Tenang, ada guide untuk pengambilan fotonya." : passportDetailsIndex == 1 ? "Jangan lupa bawa 1 paspor dan fotokopi yang berlaku minimal 3 bulan setelah tinggal di Schengen (6 bulan untuk Spanyol)" : "Selain itu, paspor harus memiliki 2 halaman kosong, diterbitkan dalam 10 tahun terakhir, dan ditandatangani.")
                                .foregroundStyle(Color("blackOpacity3"))
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            CustomButton(text: document == "Paspor" && passportDetailsIndex == 1 ? "Selanjutnya" : "OK", color: document == "Paspor" && passportDetailsIndex == 1 ? Color("primary5Opacity4") : .primary5) {
                                if document == "Paspor" && passportDetailsIndex == 1 {
                                    passportDetailsIndex += 1
                                } else {
                                    passportDetailsIndex = 1
                                    isSeeDetails = false
                                }
                            }
                            .padding()
                        }
                    }
                }
                .frame(width: proxy.size.width, alignment: .center)
            }
        }
        .presentationDetents([.fraction(isSeeDetails ? 0.7 : 0.3)])
    }
}

#Preview {
    Text(" ")
        .sheet(isPresented: .constant(true)) {
            DocumentDetailsView(document: "Paspor", account: AccountEntity(id: "1", username: "IqbalGanteng", image: Data()))
                .presentationDragIndicator(.visible)
                .environment(ProfileViewModel())
        }
}
