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

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(countries.indices, id: \.self) { index in
                            CountryCardView(
                                country: $countries[index],
                                onAddHotel: { addHotel(to: index) },
                                onRemoveHotel: { hotelIndex in
                                    removeHotel(from: index, at: hotelIndex)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                CustomButton(text: "Buat itinerary", color: Color.primary5) {
                    isItineraryListSheet.toggle()
                }
                .padding()
            }
            .navigationDestination(isPresented: $isItineraryListSheet) {
                ItineraryListSheet()
                    .environmentObject(viewModel)
            }
        }
    }

    private func addHotel(to countryIndex: Int) {
        let newHotel = Hotel(name: "")
        countries[countryIndex].hotels.append(newHotel)
    }

    private func removeHotel(from countryIndex: Int, at hotelIndex: Int) {
        countries[countryIndex].hotels.remove(at: hotelIndex)
    }
}

struct CountryCardView: View {
    @Binding var country: CountryData
    let onAddHotel: () -> Void
    let onRemoveHotel: (Int) -> Void

    var body: some View {
        CardContainer(cornerRadius: 18) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(country.name)
                        .font(.headline)
                    Spacer()
                    Text(Date.formatDateRange(startDate: country.startDate, endDate: country.endDate))
                        .font(.subheadline)
                }

                ForEach(country.hotels.indices, id: \.self) { hotelIndex in
                    HotelEntryView(
                        hotel: $country.hotels[hotelIndex],
                        onRemove: {
                            onRemoveHotel(hotelIndex)
                        }
                    )
                }

                Button(action: onAddHotel) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Hotel")
                    }
                    .foregroundColor(Color.primary5)
                }
            }
        }
    }
}


struct HotelEntryView: View {
    @State var showCalendar: Bool = false
    @Binding var hotel: Hotel
    let onRemove: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hotel Name")
                .font(.subheadline)
            TextField("Enter hotel name", text: $hotel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)

            Text("Stay Period")
                .font(.subheadline)
            DateRow(label: "Start date", showCalendar: $showCalendar, date: $hotel.startDate)
                .padding(.bottom)
                .onTapGesture {
                    showCalendar.toggle()
                }
            
            if showCalendar {
                DatePickerCalendar(startDate: $hotel.startDate, endDate: $hotel.endDate)
                    .padding(.bottom)
            }
            
            DateRow(label: "End date", showCalendar: $showCalendar, date: $hotel.endDate)
                .onTapGesture {
                    showCalendar.toggle()
                }

            Button(action: onRemove) {
                Image(systemName: "trash")
                    .foregroundColor(Color.danger5)
            }
            .padding(.vertical, 8)
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
                Hotel(name: "Rome Hotel"),
                Hotel(name: "Venice Hotel")
            ]
        )
    ]
    AiItineraryGeneratorSheet(countries: $countries)
        .environmentObject(viewModel)
}
