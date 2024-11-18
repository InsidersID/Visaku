//
//  PDFPreviewView.swift
//  Visaku
//
//  Created by Lonard Steven on 17/11/24.
//

import PDFKit
import SwiftUI

struct PDFPreviewView: UIViewRepresentable {
    let pdfDocument: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        pdfView.document = pdfDocument
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
    }
}
