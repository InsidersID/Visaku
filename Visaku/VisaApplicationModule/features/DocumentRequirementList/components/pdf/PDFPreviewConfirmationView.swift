//
//  PDFPreviewUI.swift
//  Servisa
//
//  Created by hendra on 25/10/24.
//

import SwiftUI
import PDFKit

struct PDFPreviewConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pdfDocument: PDFDocument?
    
    var body: some View {
        VStack {
            if let pdfDocument = pdfDocument {
                PDFPreviewWatchView(pdfDocument: pdfDocument)
            }
        }
        .task {
            loadPDF()
        }
    }
    
    func loadPDF() {
        if let url = Bundle.main.url(forResource: "visa_form", withExtension: "pdf"),
           let document = PDFDocument(url: url) {
            fillPDFFormFields(pdfDocument: document)
            pdfDocument = document
        }
    }
    
    func fillPDFFormFields(pdfDocument: PDFDocument){
        // Define the dictionary of form field names and their corresponding values
        let applicantPhoto = UIImage(systemName: "square.and.arrow.up")
        
        let sampleData: [String: Any] = [
            "applicantSurname": "Doe",
            "applicantSurnameAtBirth": "Smith",
            "applicantFirstname": "John",
            "applicantDateOfBirth": "1985-05-15",
            "applicantPlaceOfBirth": "Los Angeles",
            "applicantCountryOfBirth": "USA",
            "applicantNationality": "American",
            "applicantNationalityAtBirth": "American",
            "applicantNationalityOther": "Canadian",
            "applicantGenderM": true,
            "applicantGenderF": false,
            "applicantGenderA": false,
            "applicantMaritalCEL": true,
            "applicantMaritalMAR": false,
            "applicantMaritalPAC": false,
            "applicantMaritalSEP": false,
            "applicantMaritalDIV": false,
            "applicantMaritalVEU": false,
            "applicantMaritalAUT": false,
            "applicantMaritalOther": false,
            "parental1Names": "Jane Doe",
            "parental1AddressL1": "123 Elm Street",
            "parental1AddressL2": "Apt 4B",
            "parental1AddressL3": "Los Angeles",
            "parental1AddressL4": "CA",
            "parental1AddressL5": "90001",
            "parental2Names": "Robert Doe",
            "parental2AddressL1": "123 Elm Street",
            "parental2AddressL2": "Apt 4B",
            "parental2AddressL3": "Los Angeles",
            "parental2AddressL4": "CA",
            "parental2AddressL5": "90001",
            "applicantIdCardNumber": "ID12345678",
            "travelDocTypePO": "",
            "travelDocTypePD": "",
            "travelDocTypePSV": "Passport",
            "travelDocTypePOF": "",
            "travelDocTypePSP": "",
            "travelDocTypeAUT": "",
            "travelDocTypeOther": "",
            "travelDocNumber": "P12345678",
            "travelDocDateOfIssue": "2020-01-01",
            "travelDocValidUntil": "2030-01-01",
            "travelDocCountries": "USA, Canada",
            "nationalFamilySurname": "Doe",
            "nationalFamilyFirstNames": "John",
            "nationalFamilyDateOfBirth": "1985-05-15",
            "nationalFamilyNationality": "American",
            "nationalFamilyCardNumber": "NF123456",
            "applicantPhoto_af_image": "Its mine photos",
            "modificationDate": "",
            "applicationNumberPart2": "456",
            "applicationNumberPart1": "123",
            "applicationNumberCB1_af_image": applicantPhoto as Any,
            "applicationNumber": "123456",
            "relationshipCON": "",
            "relationshipENF": "",
            "relationshipPFI": "Son",
            "relationshipAAC": "",
            "relationshipPAC": "",
            "relationshipAUT": "",
            "applicantAddressL1": "123 Elm Street",
            "applicantAddressL2": "Apt 4B",
            "applicantAddressL3": "Los Angeles",
            "applicantAddressL4": "CA",
            "applicantAddressL5": "90001",
            "applicantAddressL6": "USA",
            "applicantPhone": "+1 555 123 4567",
            "applicantResidencePermitNo": "",
            "applicantResidencePermitYes": "Yes",
            "applicantResidencePermitNumber": "RP123456",
            "applicantResidencePermitValidUntil": "2025-12-31",
            "applicantOccupation": "Software Engineer",
            "applicantOccupationAddressL1": "456 Technology Drive",
            "applicantOccupationAddressL2": "Suite 200",
            "applicantOccupationAddressL3": "San Francisco",
            "purposeTOUR": "Tourism",
            "purposeTRAV": "",
            "purposeVISF": "",
            "purposeCULT": "",
            "purposeSPOR": "",
            "purposeVOFF": "",
            "purposeMEDI": "",
            "purposeETUD": "",
            "purposeATRA": "",
            "purposeAUTR": "",
            "purposeOther": "",
            "purposeOfJourneyInfo": "Vacation",
            "applicantDestinations": "France, Italy",
            "applicantDestinationFirstEntry": "France",
            "entries1": "Single Entry",
            "entries2": "",
            "entriesM": "",
            "dateOfArrival": "2024-06-15",
            "dateOfDeparture": "2024-07-15",
            "hasFingerprintsFalse": "",
            "hasFingerprintsTrue": "True",
            "fingerprintsDate": "2023-01-15",
            "formerBiometricVisa": "Yes",
            "entryPermitAuthority": "US Embassy",
            "entryPermitBeginningDate": "2024-06-15",
            "entryPermitTerminationDate": "2024-07-15",
            "host1Names": "Alice Johnson",
            "host2Names": "Bob Williams",
            "host1AddressL1": "789 Embassy St",
            "host1AddressL2": "Floor 3",
            "host1AddressL3": "Paris",
            "host2AddressL1": "456 Central Ave",
            "host2AddressL2": "Building B",
            "host2AddressL3": "Rome",
            "host1Phone": "+33 123 456 789",
            "host2Phone": "+39 987 654 321",
            "hostOrganizationAddressL1": "123 Alliance Road",
            "hostOrganizationAddressL2": "Tower 2",
            "hostOrganizationAddressL3": "London",
            "hostOrganizationAddressL4": "",
            "hostOrganizationAddressL5": "",
            "hostOrganizationAddressL6": "UK",
            "hostOrganizationPhone": "+44 123 456 789",
            "sponsorTypeM": "Individual",
            "fundingTypeM_ARG": "",
            "fundingTypeM_CHQ": "",
            "fundingTypeM_CCR": "",
            "fundingTypeM_HPP": "",
            "fundingTypeM_TPP": "",
            "fundingTypeM_AUT": "",
            "fundingTypeM_Other": "Other",
            "representativeNames": "Michael Doe",
            "representativeAddressL1": "987 Lawyer St",
            "representativeAddressL2": "Suite 500",
            "representativeAddressL3": "New York",
            "representativeAddressL4": "NY",
            "representativeAddressL5": "10001",
            "representativeAddressL6": "USA",
            "representativePhone": "+1 555 987 6543",
            "townAndDateTime": "New York, 2024-06-01"
        ]
        
        // Access each form field directly by name and assign the value
        for i in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: i) else { continue }
            
            for annotation in page.annotations {
                guard let fieldName = annotation.fieldName else { continue }
                print(fieldName)
                // Check if field exists in the dictionary and process based on field type
                 if let fieldValue = sampleData[fieldName] {
                    if let stringValue = fieldValue as? String {
                        annotation.widgetStringValue = stringValue
                    } else if let boolValue = fieldValue as? Bool, boolValue {
                        annotation.buttonWidgetState = .onState
                    }
                }
            }
        }
        
    }
}

#Preview {
    PDFPreviewConfirmationView()
}
