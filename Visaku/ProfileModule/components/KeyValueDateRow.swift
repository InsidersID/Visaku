import SwiftUI

struct KeyValueDateRow: View {
    let key: String
    @Binding var dateValue: Date
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
                    DatePicker("", selection: $dateValue, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                } else {
                    Text(formattedDate(dateValue))
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
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    @Previewable @State var birthDate: Date = Date()
    KeyValueDateRow(key: "Birth Date", dateValue: $birthDate)
}
