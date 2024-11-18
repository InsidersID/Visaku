import SwiftUI
import PDFKit

public class PDFConverterViewModel: ObservableObject {
    public init() {}
    
    func convertPDFToImages(pdfURL: URL) -> [UIImage]? {
        guard let pdfDocument = PDFDocument(url: pdfURL) else {
            return nil
        }
        
        var images: [UIImage] = []
        
        for pageNum in 0..<pdfDocument.pageCount {
            if let pdfPage = pdfDocument.page(at: pageNum) {
                let pdfPageSize = pdfPage.bounds(for: .mediaBox)
                let renderer = UIGraphicsImageRenderer(size: pdfPageSize.size)
                
                let image = renderer.image { context in
                    UIColor.white.set()
                    context.fill(pdfPageSize)
                    context.cgContext.translateBy(x: 0.0, y: pdfPageSize.size.height)
                    context.cgContext.scaleBy(x: 1.0, y: -1.0)
                    
                    pdfPage.draw(with: .mediaBox, to: context.cgContext)
                }
                
                images.append(image)
            }
        }
        
        return images
    }
    
    // Function to create PDF from UIImage
    func convertPDFToImage(from image: UIImage) -> URL? {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: image.size))
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
        
        // Save PDF data to a temporary location
        let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent("image.pdf")
        do {
            try pdfData.write(to: pdfURL)
            return pdfURL
        } catch {
            print("Failed to save PDF: \(error)")
            return nil
        }
    }
}

/// Use Case PDF to Image:
//if let pdfURL = Bundle.main.url(forResource: "example", withExtension: "pdf") {
//    if let images = PDFConverterViewModel().convertPDFToImages(pdfURL: pdfURL) {
//    for image in images {
//        // Do something with each image
//    }
// }
//}


/// Use Case Image to PDF:
//if let pdfURL = PDFConverterViewModel().convertPDFToImage(from: UIImage(imageLiteralResourceName: "")) {
//    guard let pdfDocument = PDFDocument(url: pdfURL) else {
//        print("Error converting PDF to image")
//    }
//}
