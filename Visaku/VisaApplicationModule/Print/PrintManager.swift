//
//  PrintManager.swift
//  CameraIntensityTest
//
//  Created by Lonard Steven on 04/11/24.
//
import UIKit

class PrintManager {
    static let shared = PrintManager()
    
    private init() {
        
    }
    
    func printFilledVisaApplicationForm(completion: @escaping () -> Void) {
        guard let pdfURL = Bundle.main.url(forResource: "visa_form", withExtension: "pdf"),
              let pdfData = try? Data(contentsOf: pdfURL) else {
            print("Couldn't process or find a PDF visa application form...")
            return
        }
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        
        printInfo.outputType = .general
        printInfo.jobName = "Visaku PDF Application Form Print"
        printController.printInfo = printInfo
        
        printController.printingItem = pdfData
        printController.present(animated: true, completionHandler: nil)
    }
}
