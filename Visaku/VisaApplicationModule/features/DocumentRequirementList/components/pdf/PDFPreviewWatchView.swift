//
//  PDFPreviewView.swift
//  Servisa
//
//  Created by hendra on 25/10/24.
//

import SwiftUI
import PDFKit

struct PDFPreviewWatchView: UIViewRepresentable {
    let pdfDocument: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct PDFPreviewVisa: View {

    @State private var pdfDocument: PDFDocument?

    var body: some View {
        VStack {
            if let pdfDocument = pdfDocument {
                PDFPreviewWatchView(pdfDocument: pdfDocument)
            } else {
                Text("No PDF Loaded")
            }
        }
        
    }
    
    
}

#Preview {
    PDFPreviewVisa()
}
