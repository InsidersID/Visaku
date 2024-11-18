import Foundation
import SwiftUI
import RepositoryModule

// Reusable KeyValuePickerRow for any Enum conforming to CaseIterable and RawRepresentable
struct KeyValuePickerRow<T: RawRepresentable & CaseIterable & Hashable>: View where T.RawValue == String {
    let key: String
    @Binding var selectedOption: T
    @State private var isEditing: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(key)
                    .font(.custom("Inter-Semibold", size: 15))
                    .foregroundStyle(Color.blackOpacity3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading) {
                if isEditing {
                    Picker(selection: $selectedOption, label: Text(key)) {
                        // Explicitly convert `T.allCases` to an array to ensure it conforms to `RandomAccessCollection`
                        ForEach(Array(T.allCases), id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                } else {
                    Text(selectedOption.rawValue)
                        .font(.custom("Inter-Semibold", size: 15))
                        .foregroundStyle(Color.blackOpacity5)
                        .padding(.horizontal, 6)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                isEditing.toggle()
            }) {
                Image(systemName: isEditing ? "checkmark" : "pencil")
                    .foregroundColor(.black)
            }
        }
        .padding(.vertical, 8)
    }
}

struct KeyValuePickerRow_Previews: PreviewProvider {
    @State static var gender: GenderEnum = .male

    static var previews: some View {
        VStack {
            KeyValuePickerRow<GenderEnum>(key: "Gender", selectedOption: $gender)
        }
        .padding()
    }
}
