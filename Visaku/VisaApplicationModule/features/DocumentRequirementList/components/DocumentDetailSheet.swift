//
//  DocumentDetailSheet.swift
//  Visaku
//
//  Created by hendra on 11/11/24.
//

import SwiftUI
import UIComponentModule

struct DocumentDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    var title: String
    var description: String
    var body: some View {
        VStack {
            Image("document")
                .resizable()
                .scaledToFit()
                .padding()
            
            Text(description)
                .foregroundStyle(Color.blackOpacity3)
                .multilineTextAlignment(.center)
                .padding()
            
            CustomButton(text: "OK", color: Color.primary5) {
                dismiss()
            }
            .padding()
        }
    }
}

#Preview {
    DocumentDetailSheet(title: "tes", description: "tes")
}
