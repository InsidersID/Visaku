import SwiftUI

struct KeyValueRow: View {
    let key: String
    @Binding var value: String
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
                    TextField(key, text: $value)
                        .font(.custom("Inter-Semibold", size: 15))
                        .foregroundStyle(Color.blackOpacity5)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(value)
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


#Preview {
    @Previewable @State var name: String = "Mira Setiawan"
    KeyValueRow(key: "Nama", value: $name)
}
