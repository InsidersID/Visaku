import SwiftUI
import UIComponentModule

public struct AddOnInformationView: View {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left.circle")
                            .font(.title)
                            .padding(.leading)
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("Informasi Tambahan")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.trailing)
                        .padding(.trailing)
                    
                    Spacer()
                }
                
//                Rectangle()
//                    .scaledToFit()
//                    .foregroundStyle(.secondary)
//                    .padding(.horizontal, 60)
//                    .padding(.bottom)
                VStack {
                    Image("applicationForm")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200)
                        .padding()
                }
                
                CardContainer(cornerRadius: 16) {
                    HStack {
                        Text("Informasi bepergian (1/4)")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                    }
                }
                .padding(.horizontal)
                .padding(.horizontal)
                
                CardContainer(cornerRadius: 16) {
                    HStack {
                        Text("Visa Schengen (1/4)")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                    }
                }
                .padding(.horizontal)
                .padding(.horizontal)
                
                CardContainer(cornerRadius: 16) {
                    HStack {
                        Text("Biaya perjalanan (1/4)")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                    }
                }
                .padding(.horizontal)
                .padding(.horizontal)
                
                CardContainer(cornerRadius: 16) {
                    HStack {
                        Text("Biaya perjalanan (1/4)")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                    }
                }
                .padding(.horizontal)
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

#Preview {
    AddOnInformationView()
}
