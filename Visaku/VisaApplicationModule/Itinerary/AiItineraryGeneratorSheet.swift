import SwiftUI
import UIComponentModule
import RepositoryModule

struct AiItineraryGeneratorSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var isItineraryListSheet = false
    @Binding var countries: [CountryData]
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("AI Itinerary Generator")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .padding()
                
                Text("Daftar tempat tinggal")
                    .font(.headline)
                
                ForEach($countries) { $country in
                    CardContainer(cornerRadius: 18) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(country.name)
                                    .font(.headline)
                                Spacer()
                                Text(formatDateRange(startDate: country.startDate, endDate: country.endDate))
                                                                .font(.subheadline)
                            }
                            
                            ForEach($country.hotels) { $hotel in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Hotel Name")
                                        .font(.subheadline)
                                    TextField("Enter hotel name", text: $hotel.name)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .frame(maxWidth: .infinity)
                                    
                                    Text("Stay Period")
                                        .font(.subheadline)
                                    TextField("Enter stay period", text: $hotel.stayPeriod)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .frame(maxWidth: .infinity)
                                    
                                    Button(action: {
                                        if let index = country.hotels.firstIndex(where: { $0.id == hotel.id }) {
                                            country.hotels.remove(at: index)
                                        }
                                  }) {
                                      Image(systemName: "trash")
                                          .foregroundColor(Color.danger5)
                                  }
                                .padding(.vertical, 8)
                            }
                            
                            Button(action: {
                                print("trigger")
                                    let newHotel = Hotel(name: "", stayPeriod: "")
                                    if let countryIndex = countries.firstIndex(where: { $0.id == country.id }) {
                                        countries[countryIndex].hotels.append(newHotel)
                                        // Log for debugging
                                        print("Updated hotels: \(countries[countryIndex].hotels)")
                                    }
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add Hotel")
                                }
                                .foregroundColor(Color.primary5)
                            }
                        }
                    }
                }
                
                Spacer()
                CustomButton(text: "Buat itinerary", color: Color.primary5) {
                    isItineraryListSheet.toggle()
                }
            }
            .padding(.horizontal, 20)
            .navigationDestination(isPresented: $isItineraryListSheet) {
                ItineraryListSheet()
                    .environmentObject(viewModel)
            }
        }
    }
    
    private func formatDateRange(startDate: Date?, endDate: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        // Safely unwrap the dates and format them
        if let start = startDate, let end = endDate {
            let startString = formatter.string(from: start)
            let endString = formatter.string(from: end)
            return "\(startString) - \(endString)"
        } else {
            return "No date range"
        }
    }
}

#Preview {
    @Previewable @ObservedObject var viewModel: CountryVisaApplicationViewModel = .init()
    @Previewable @State var countries = [
        CountryData(
            name: "Italia",
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()),
            hotels: [
                Hotel(name: "Rome Hotel", stayPeriod: "Jun 22 2024 - Jun 24 2024"),
                Hotel(name: "Venice Hotel", stayPeriod: "Jun 24 2024 - Jun 26 2024")
            ]
        )
    ]
    AiItineraryGeneratorSheet(countries: $countries)
        .environmentObject(viewModel)
}
