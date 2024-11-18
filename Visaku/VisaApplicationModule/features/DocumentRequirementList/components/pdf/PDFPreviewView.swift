//
//  PDFPreviewView.swift
//  Visaku
//
//  Created by Lonard Steven on 17/11/24.
//

import PDFKit
import SwiftUI

struct PDFPreviewView: UIViewRepresentable {
    let pdfURL: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {

    }
}
