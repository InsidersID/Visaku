import SwiftUI

struct KeyValueRow: View {
    let key: String
    @Binding var value: String
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
                    TextField(key, text: $value)
                        .bold()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(value)
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
    @Previewable @State var name: String = "Mira Setiawan"
    KeyValueRow(key: "Nama", value: $name)
}
