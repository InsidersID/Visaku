import SwiftUI
import UIComponentModule
import RepositoryModule

struct UploadDocumentsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(ProfileViewModel.self) var profileViewModel
    public var document: String
    @State private var isUpload: Bool = false
    @State private var isSeeDetails: Bool = false
    public var account: AccountEntity
    @State public var status: DocumentStatus
    @State private var passportDetailsIndex = 1
    
    public init (document: String, account: AccountEntity, status: DocumentStatus = .undone) {
        self.document = document
        self.account = account
        self.status = status
    }
    
    var body: some View {
        VStack {
            Text(document)
                .font(Font.custom("Inter", size: 16))
                .padding(.vertical)
                .padding(.bottom)
            
            HStack {
                Button {
                    isUpload = true
                } label: {
                    ZStack {
                        Image(systemName: "circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(.blue)
                        Image(systemName: "document.fill")
                            .imageScale(.small)
                            .foregroundStyle(.white)
                    }
                    
                    Text("Upload file (.pdf)")
                        .font(Font.custom("Inter", size: 16))
                        .foregroundStyle(.black)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            
            HStack {
                Button {
                    isUpload = true
                } label: {
                    ZStack {
                        Image(systemName: "circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(.blue)
                        Image(systemName: "photo")
                            .imageScale(.small)
                            .foregroundStyle(.white)
                    }
                    
                    Text("Upload gambar (.jpg)")
                        .font(Font.custom("Inter", size: 16))
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
                            .foregroundStyle(.blue)
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
        .presentationDetents([.fraction(0.3)])
    }
}

#Preview {
    Text(" ")
        .sheet(isPresented: .constant(true)) {
            UploadDocumentsView(document: "Paspor", account: AccountEntity(id: "1", username: "IqbalGanteng"))
                .presentationDragIndicator(.visible)
                .environment(ProfileViewModel())
        }
}
