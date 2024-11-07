import SwiftUI
import RepositoryModule

struct KeyValueDropdownRow<T: RawRepresentable & CaseIterable & Hashable & Sendable>: View where T.RawValue == String {
    let key: String
    @Binding var selectedOption: T
    @State private var isEditing: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(key)
                    .font(.body)
                    .bold()
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading) {
                if isEditing {
                    Picker(selection: $selectedOption, label: Text(key)) {
                        ForEach(Array(T.allCases), id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Dropdown style
                } else {
                    Text(selectedOption.rawValue)
                        .padding(.horizontal, 6)
                        .bold()
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

#Preview {
    @Previewable @State var status: MaritalStatusEnum = .single
    KeyValueDropdownRow(key: "Marital Status", selectedOption: $status)
}
