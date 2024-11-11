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
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top, 24)
            Image("document")
                .resizable()
                .scaledToFit()
                .padding()
            
            Text(description)
                .foregroundStyle(.secondary)
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
