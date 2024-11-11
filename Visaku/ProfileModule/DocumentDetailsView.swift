import SwiftUI
import UIComponentModule
import RepositoryModule

public struct DocumentDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var profileViewModel: ProfileViewModel
    public var document: String
    @State private var isUpload: Bool = false
    @State private var isSeeDetails: Bool = false
    public var account: AccountEntity
    @State public var status: DocumentStatus
    
    public init (document: String, account: AccountEntity, status: DocumentStatus = .undone) {
        self.document = document
        self.account = account
        self.status = status
    }
    
    public var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Text(document)
                        .font(Font.custom("Inter", size: 16))
                        .padding(.top)
                        .padding(.vertical)
                    
                    if !isUpload && !isSeeDetails {
                        VStack {
                            HStack {
                                Button {
                                    isUpload = true
                                } label: {
                                    Image(systemName: "square.and.arrow.up.circle.fill")
                                        .imageScale(.large)
                                        .foregroundStyle(.blue)
                                    
                                    Text("Upload dari device")
                                        .font(Font.custom("Inter", size: 16))
                                        .foregroundStyle(.black)
                                }
                                
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack {
                                NavigationLink {
                                    switch document {
                                    case "KTP":
                                        KTPPreviewSheet(account: account)
                                        
                                    case "Paspor":
                                        PassportPreviewSheet(account: account)
                                        
                                    default:
                                        Text("Document type not handled")
                                    }
                                } label: {
                                    ZStack {
                                        Image(systemName: "circle.fill")
                                            .imageScale(.large)
                                            .foregroundStyle(.blue)
                                        Image(systemName: "camera")
                                            .imageScale(.small)
                                            .foregroundStyle(.white)
                                    }
                                    
                                    Text(document == "Foto" ? "Ambil foto" : "Scan dokumen")
                                        .font(Font.custom("Inter", size: 16))
                                        .foregroundStyle(.black)
                                }
                                
                                
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical)
                            
                            HStack {
                                Button {
                                    isSeeDetails = true
                                } label: {
                                    Image(systemName: "eye.circle.fill")
                                        .imageScale(.large)
                                        .foregroundStyle(.blue)
                                    
                                    Text("Lihat ketentuan")
                                        .font(Font.custom("Inter", size: 16))
                                        .foregroundStyle(.black)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        
                    } else if isUpload {
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(.black.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [6, 6]))
                                    .padding()
                                    .frame(width: proxy.size.width, height: proxy.size.width*0.9)
                                
                                VStack {
                                    ZStack {
                                        Circle()
                                            .fill(.clear)
                                            .stroke(.secondary)
                                            .frame(width: proxy.size.width*0.1)
                                        
                                        Image(systemName: "document.fill")
                                            .foregroundStyle(Color(red: 0, green: 0.55, blue: 0.85))
                                    }
                                    
                                    Text("Klik untuk upload PDF")
                                        .font(Font.custom("Inter", size: 16))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color(red: 0, green: 0.55, blue: 0.85))
                                    
                                    Text("(Max. file size: 25 MB)")
                                        .font(Font.custom("Inter", size: 13))
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            CustomButton(text: "Browse dokumen", color: Color(red: 0, green: 0.55, blue: 0.85), buttonHeight: 50) {
                                isUpload = false
                                status = .done
                                dismiss()
                            }
                            .padding()
                        }
                    } else {
                        VStack {
                            Spacer()
                            
                            Text("Yuk, ambil foto terbaikmu untuk pengajuan visa. Tenang, ada guide untuk pengambilan fotonya.")
                                .foregroundStyle(.secondary)
                            
                            CustomButton(text: "OK", color: .blue) {
                                isSeeDetails = false
                            }
                            .padding()
                        }
                    }
                }
                .frame(width: proxy.size.width, alignment: .center)
            }
        }
        .presentationDetents([.fraction(isUpload || isSeeDetails ? 0.7 : 0.3)])
    }
}

#Preview {
    Text(" ")
        .sheet(isPresented: .constant(true)) {
            DocumentDetailsView(document: "Paspor", account: AccountEntity(id: "1", username: "IqbalGanteng", image: Data()))
                .presentationDragIndicator(.visible)
                .environmentObject(ProfileViewModel())
        }
}
