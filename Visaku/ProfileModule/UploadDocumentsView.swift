import SwiftUI
import UIComponentModule
import RepositoryModule

struct UploadDocumentsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(ProfileViewModel.self) var profileViewModel
    public var document: String
    @StateObject public var account: AccountEntity
    @State public var status: DocumentStatus
    
    public init (document: String, account: AccountEntity? = nil, status: DocumentStatus = .undone) {
        self.document = document
        self._account = StateObject(wrappedValue: account ?? AccountEntity(id: "", username: "", image: Data()))
        self.status = status
    }
    
    var body: some View {
        VStack {
            Text(document)
                .font(Font.custom("Inter-Regular", size: 16))
                .padding(.vertical)
                .padding(.bottom)
            
            HStack {
                Button {
                    profileViewModel.isUploadFile = true
                    dismiss()
                } label: {
                    ZStack {
                        Image(systemName: "circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(Color.primary5)
                        Image(systemName: "document.fill")
                            .imageScale(.small)
                            .foregroundStyle(.white)
                    }
                    
                    Text("Upload file (.pdf)")
                        .font(Font.custom("Inter-Regular", size: 16))
                        .foregroundStyle(.black)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            
            HStack {
                Button {
                    DispatchQueue.main.async {
                            switch document {
                            case "KTP":
                                print("KTP Upload")
                                profileViewModel.isUploadImageForKTP = true
                            case "Paspor":
                                print("Passport Upload")
                                profileViewModel.isUploadImageForPassport = true
                            case "Foto":
                                print("Photo Upload")
                                profileViewModel.isUploadImageForFoto = true
                            default:
                                print("Others Upload")
                                profileViewModel.isUploadImageForOthers = true
                            }
                        }

                   dismiss()
                } label: {
                    ZStack {
                        Image(systemName: "circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(Color.primary5)
                        Image(systemName: "photo")
                            .imageScale(.small)
                            .foregroundStyle(.white)
                    }
                    
                    Text("Upload gambar (.jpg)")
                        .font(Font.custom("Inter-Regular", size: 16))
                        .foregroundStyle(.black)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical)
            
            HStack {
                Button {
                    profileViewModel.selectedDocument = .init(name: document)
                    dismiss()
                } label: {
                    ZStack {
                        Image(systemName: "circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(Color.primary5)
                        Image(systemName: "xmark")
                            .imageScale(.small)
                            .foregroundStyle(.white)
                    }
                    
                    Text("Batal")
                        .font(Font.custom("Inter", size: 16))
                        .foregroundStyle(.black)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .presentationDetents([.fraction(0.35)])
    }
}

#Preview {
    Text(" ")
        .sheet(isPresented: .constant(true)) {
            UploadDocumentsView(document: "Paspor", account: AccountEntity(id: "1", username: "IqbalGanteng", image: Data()))
                .presentationDragIndicator(.visible)
                .environment(ProfileViewModel())
        }
}
