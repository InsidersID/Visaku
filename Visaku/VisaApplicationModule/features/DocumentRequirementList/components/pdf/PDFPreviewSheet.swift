//
//  PDFPreviewSheet.swift
//  Visaku
//
//  Created by Lonard Steven on 17/11/24.
//

import SwiftUI
import Foundation
import UIComponentModule
import PDFKit
import RepositoryModule

public struct PDFPreviewSheet: View {
    @StateObject var viewModel = CountryVisaApplicationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State var pdfDocument: PDFDocument?
    
    var trip: TripEntity?
    
    @StateObject private var pdfPreviewConfirmationViewModel: PDFPreviewConfirmationViewModel
    
    public init(trip: TripEntity?) {
        self.trip = trip
        _pdfPreviewConfirmationViewModel = StateObject(wrappedValue: PDFPreviewConfirmationViewModel())
    }
    
    public var body: some View {
        VStack {
            Text("Tinjauan PDF")
                .font(Font.custom("Inter", size: 16))
                .padding(.top, 32)
                .padding(.bottom, 16)
            
            if let pdfDocument = pdfDocument {
                PDFPreviewView(pdfDocument: pdfDocument)
                    .frame(height: 500)
                    .background(.gray.opacity(0.3))
                    .cornerRadius(16)
                    .edgesIgnoringSafeArea(.all)
                    .padding()
                
                CustomButton(text: "Print PDF", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    PrintManager.shared.printFilledVisaApplicationForm {
                        viewModel.isShowPreviewVisaApplicationForm = false
                        dismiss()
                    }
                }
                .padding(.horizontal)
                
                CustomButton(text: "Unduh PDF", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 8) {
                    PDFDownload.shared.downloadPDF {
                        viewModel.isShowPreviewVisaApplicationForm = false
                        dismiss()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray)
                    .frame(height: 200)
                    .overlay {
                        VStack {
                            Image(systemName: "document.badge.ellipsis")
                                .resizable()
                                .frame(width: 96, height: 64)
                                .foregroundStyle(.white)
                                .padding()
                                
                            Text("Sepertinya file PDFmu tidak ditemukan \n atau gagal diakses.")
                                .font(.custom("Inter", size: 16))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    .padding()
                
                CustomButton(text: "Tutup", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) { 
                    viewModel.isShowPreviewVisaApplicationForm = false
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .presentationDetents([.fraction(0.98)])
        .task {
            loadPDF()
        }
        .onAppear {
            loadTripData()
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
        
        let placeDateOfBirth = Helper.parseIdentityData(trip?.account?.identityCard?.placeDateOfBirth ?? "JAKARTA, 01-01-1990")
        
        let sampleData: [String: Any] = [
            "applicantSurname": trip?.account?.identityCard?.name ?? "Name",
            "applicantSurnameAtBirth": trip?.account?.identityCard?.name ?? "Surname at Birth",
            "applicantFirstname": trip?.account?.identityCard?.name ?? "First Name",
            "applicantDateOfBirth": placeDateOfBirth?.dateOfBirth ?? "Date of Birth",
            "applicantPlaceOfBirth": placeDateOfBirth?.placeOfBirth ?? "Place of Birth",
            "applicantCountryOfBirth": trip?.account?.identityCard?.nationality ?? "Country of Birth",
            "applicantNationality": trip?.account?.identityCard?.nationality ?? "Nationality",
            "applicantNationalityAtBirth": trip?.account?.identityCard?.countryBorn ?? "Nationality at Birth",
            "applicantNationalityOther": "",
            "applicantGenderM": trip?.account?.identityCard?.gender == .male ? true : false,
            "applicantGenderF": trip?.account?.identityCard?.gender == .female ? true : false,
            "applicantGenderA": false,
            "applicantMaritalCEL": trip?.account?.identityCard?.maritalStatus == .single ? true : false,
            "applicantMaritalMAR": trip?.account?.identityCard?.maritalStatus == .married ? true : false,
            "applicantMaritalPAC": false,
            "applicantMaritalSEP": false,
            "applicantMaritalDIV": trip?.account?.identityCard?.maritalStatus == .divorced ? true : false,
            "applicantMaritalVEU": trip?.account?.identityCard?.maritalStatus == .widowed ? true : false,
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
            "travelDocTypePO": trip?.account?.passport?.passportType == .regular ? true : false,
            "travelDocTypePD": trip?.account?.passport?.passportType == .diplomatic ? true : false,
            "travelDocTypePSV": trip?.account?.passport?.passportType == .service ? true : false,
            "travelDocTypePOF": trip?.account?.passport?.passportType == .regular ? true : false,
            "travelDocTypePSP": "",
            "travelDocTypeAUT": "",
            "travelDocTypeOther": "",
            "travelDocNumber": trip?.account?.passport?.passportNo ?? "Passport Number",
            "travelDocDateOfIssue": trip?.account?.passport?.issueDate ?? "Passport Issue Date",
            "travelDocValidUntil": trip?.account?.passport?.expirationDate ?? "Passport Expiration Date",
            "travelDocCountries": trip?.account?.passport?.passportIssuePlace ?? "Passport Place Type",
            "nationalFamilySurname": "Doe",
            "nationalFamilyFirstNames": "John",
            "nationalFamilyDateOfBirth": "1985-05-15",
            "nationalFamilyNationality": "American",
            "nationalFamilyCardNumber": "NF123456",
            "applicantPhoto_af_image": "Its mine photos",
            "modificationDate": "",
            "applicationNumberPart2": "",
            "applicationNumberPart1": "",
            "applicationNumberCB1_af_image": applicantPhoto as Any,
            "applicationNumber": "",
            "relationshipCON": "",
            "relationshipENF": "",
            "relationshipPFI": "",
            "relationshipAAC": "",
            "relationshipPAC": "",
            "relationshipAUT": "",
            "applicantAddressL1": trip?.account?.identityCard?.address ?? "Address 1",
            "applicantAddressL2": trip?.account?.additionalInformation?.addressCity ?? "Address 2",
            "applicantAddressL3": trip?.account?.additionalInformation?.addressCountry ?? "Address 3",
            "applicantAddressL4": trip?.account?.additionalInformation?.addressPostalCode ?? "Address 4",
            "applicantAddressL5": "",
            "applicantAddressL6": "",
            "applicantPhone": trip?.account?.additionalInformation?.addressTelephone ?? "Phone Number",
            "applicantResidencePermitNo": "",
            "applicantResidencePermitYes": "Yes",
            "applicantResidencePermitNumber": "RP123456",
            "applicantResidencePermitValidUntil": "2025-12-31",
            "applicantOccupation": trip?.account?.identityCard?.job ?? "Occupation",
            "applicantOccupationAddressL1": trip?.account?.additionalInformation?.companyAddress ?? "Occupation Address 1",
            "applicantOccupationAddressL2": (trip?.account?.additionalInformation?.companyCity ?? "Company City") + ", " + (trip?.account?.additionalInformation?.companyCountry ?? "Company Country"),
            "applicantOccupationAddressL3": (trip?.account?.additionalInformation?.companyTelephone ?? "Company Telephone") + ", " + (trip?.account?.additionalInformation?.companyPostalCode ?? "Company Postal Code"),
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
            "applicantDestinations": trip?.countries.map { $0.name }.joined(separator: ", ") ?? "Countries",
            "applicantDestinationFirstEntry": trip?.countries.first?.name ?? "First country of entry",
            "entries1": "Single Entry",
            "entries2": "",
            "entriesM": "",
            "dateOfArrival": trip?.countries.first?.startDate ?? "Date of Arrival",
            "dateOfDeparture": trip?.countries.last?.endDate ?? "Date of Departure",
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
    
    private func loadTripData() {
        guard let tripId = trip?.id else {
            print("Error occurred when getting trip id")
            return
        }
        pdfPreviewConfirmationViewModel.fetchAccountDataFromTrip(tripId)
    }
}
