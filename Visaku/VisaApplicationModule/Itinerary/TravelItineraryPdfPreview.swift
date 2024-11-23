//
//  TravelItineraryPdfPreview.swift
//  Visaku
//
//  Created by hendra on 22/11/24.
//

import SwiftUI
import PDFKit
import UIComponentModule

struct TravelItineraryPdfPreview: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    @Binding var itinerary: Itinerary
    
    var body: some View {
        VStack {
            ExportableItineraryView(itinerary: $itinerary)
            CustomButton(text: "Export as PDF", color: .primary5, action: {
                exportPDF()
            })
            .padding()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Itinerary Preview")
                    .font(.system(size: 24))
                    .bold()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .fontWeight(.semibold)
                        .font(.system(size: 17))
                        .padding(10)
                        .background(Circle().fill(Color.white))
                        .foregroundColor(.black)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
            }
        }
    }
    
    func exportPDF() {
        let screenWidth = UIScreen.main.bounds.width
        let pageHeight = UIScreen.main.bounds.height
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: screenWidth, height: pageHeight))

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("travelItinerary.pdf")
        
        do {
            try pdfRenderer.writePDF(to: tempURL) { context in
                context.beginPage()
                let staticView = ExportableItineraryView(itinerary: $itinerary)
                let controller = UIHostingController(rootView: staticView)
                

                if let view = controller.view {
                    view.frame = context.pdfContextBounds
                    view.backgroundColor = .white
                    view.drawHierarchy(in: context.pdfContextBounds, afterScreenUpdates: true)
                }
            }
            
            let documentPicker = UIDocumentPickerViewController(forExporting: [tempURL], asCopy: true)
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = scene.windows.first?.rootViewController {
                rootViewController.present(documentPicker, animated: true)
            }
        } catch {
            print("Failed to generate PDF: \(error)")
        }
    }
}


#Preview {
    @Previewable @State var itinerary: Itinerary = Itinerary(days: [
        Day(
            title: "Day 1",
            date: "2024-11-22",
            city: "Milan", morning: Activity(placeName: "Milan Airport", placeLatitude: 45.4654, placeLongitude: 9.1865, activity: "Arrival & hotel check-in"),
            afternoon: Activity(placeName: "Duomo di Milano", placeLatitude: 45.4641, placeLongitude: 9.1919, activity: "Visit Duomo Cathedral"),
            night: Activity(placeName: "Navigli District", placeLatitude: 45.4384, placeLongitude: 9.1711, activity: "Dinner in Navigli")
        ),
        Day(
            title: "Day 2",
            date: "2024-11-23",
            city: "Roma", morning: Activity(placeName: "Sforza Castle", placeLatitude: 45.4707, placeLongitude: 9.1795, activity: "Visit Sforza Castle"),
            afternoon: Activity(placeName: "Brera District", placeLatitude: 45.4706, placeLongitude: 9.1852, activity: "Explore Brera Art District"),
            night: Activity(placeName: "La Scala", placeLatitude: 45.4669, placeLongitude: 9.1903, activity: "Watch a performance at La Scala Opera House")
        ),
        Day(
            title: "Day 3",
            date: "2024-11-24",
            city: "San Marino", morning: Activity(placeName: "Santa Maria delle Grazie", placeLatitude: 45.4665, placeLongitude: 9.1802, activity: "Visit The Last Supper painting"),
            afternoon: Activity(placeName: "Galleria Vittorio Emanuele II", placeLatitude: 45.4700, placeLongitude: 9.1900, activity: "Shopping at Galleria Vittorio Emanuele II"),
            night: Activity(placeName: "Piazza del Duomo", placeLatitude: 45.4641, placeLongitude: 9.1919, activity: "Evening stroll around Piazza del Duomo")
        )
    ])
    TravelItineraryPdfPreview(itinerary: $itinerary)
}

struct ExportableItineraryView: View {
    @Binding var itinerary: Itinerary
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .center) {
                    Text("Travel Itinerary")
                    Text("(Milan/Rome-10 Days Trip)")
                }
                .frame(maxWidth: .infinity, alignment: Alignment(horizontal: .center, vertical: .top))
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Flight#: T6ED (Reservation Manila to Milan)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("FULL NAME: ")
                        Text("PASSPORT NUMBER: ")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                
                VStack(spacing: 0) {
                    ForEach(itinerary.days) { day in
                        CardItineraryDetail(day: day)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
        }
    }
}

struct CardItineraryDetail: View {
    @State var day: Day
    var body: some View {
        HStack {
            VStack(spacing: 16) {
                Text(day.title)
                Text(day.city)
            }
            .modifier(VerticalRotationModifier(rotation: .anticlockwise))
            .frame(maxHeight: .infinity)
            Divider()
                .frame(width: 1)
                .overlay {
                    Color.black
                }
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("MORNING: ")
                        .frame(minWidth: 112, alignment: .leading)
                    Text(day.morning.activity)
                }
                HStack(alignment: .top) {
                    Text("AFTERNOON: ")
                        .frame(minWidth: 112, alignment: .leading)
                    Text(day.afternoon.activity)
                }
                HStack(alignment: .top) {
                    Text("EVENING: ")
                        .frame(minWidth: 112, alignment: .leading)
                    Text(day.night.activity)
                }
            }
            .frame(width: 300)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .border(Color.black, width: 1)
    }
}
struct VerticalRotationModifier: ViewModifier {
    @State private var contentSize = CGSize.zero
    let rotation: VerticalRotationType
    
    func body(content: Content) -> some View {
        content
            .fixedSize()
            .overlay(GeometryReader { proxy in
                Color.clear.preference(key: ContentSizePreferenceKey.self, value: proxy.size)
            })
            .onPreferenceChange(ContentSizePreferenceKey.self, perform: { newSize in
                contentSize = newSize
            })
            .rotationEffect(rotation.asAngle)
            .frame(width: contentSize.height, height: contentSize.width)
    }

    enum VerticalRotationType {
        case clockwise
        case anticlockwise
        
        var asAngle: Angle {
            switch(self) {
            case .clockwise:
                return .degrees(90)
            case .anticlockwise:
                return .degrees(-90)
            }
        }
    }
    
    private struct ContentSizePreferenceKey: PreferenceKey {
        static var defaultValue: CGSize = .zero

        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
}
