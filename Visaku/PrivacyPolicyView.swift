import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Terakhir di-update 18/12/2024")
                            .font(.custom("Inter-Medium", size: 16))
                            .foregroundStyle(Color.blackOpacity3)
                            .padding(.bottom)
                        
                        Text("Visaku menghargai privasi Anda dan berkomitmen untuk melindungi data pribadi Anda.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi Anda ketika menggunakan aplikasi Visaku. Harap baca Kebijakan Privasi ini dengan seksama untuk memahami bagaimana kami mengelola data pribadi Anda.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                            .padding(.bottom)
                        
                        Text("1.⁠ ⁠Informasi yang Kami Kumpulkan")
                            .font(.custom("Inter-Bold", size: 16))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Kami mengumpulkan informasi yang diperlukan untuk menyediakan layanan di aplikasi Visaku, yang dapat dibagi menjadi dua kategori:")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Data Identitas: Informasi yang diambil dari KTP, paspor, atau dokumen lain yang Anda unggah melalui aplikasi untuk pengisian otomatis formulir visa. Informasi ini dapat mencakup nama, tanggal lahir, nomor paspor, alamat, dan kewarganegaraan.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Data Penggunaan: Informasi teknis mengenai cara Anda menggunakan aplikasi, seperti fitur yang sering Anda gunakan, interaksi dengan antarmuka, serta preferensi Anda.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                            .padding(.bottom)
                        
                        Text("2.⁠ ⁠Penyimpanan Data")
                            .font(.custom("Inter-Bold", size: 16))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Visaku memastikan bahwa semua data identitas dan dokumen yang diunggah melalui aplikasi disimpan secara lokal di perangkat Anda. Kami tidak menyimpan atau mengakses informasi pribadi ini di server eksternal atau pihak ketiga.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                            .padding(.bottom)
                        
                        Text("3.⁠ ⁠Penggunaan Data dalam Fitur AI Itinerary Generator")
                            .font(.custom("Inter-Bold", size: 16))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Fitur AI Itinerary Generator adalah satu-satunya fitur dalam Visaku yang membutuhkan pengiriman data ke layanan eksternal. Ketika Anda menggunakan fitur ini, kami hanya akan mengirimkan alamat tempat tinggal Anda selama di area Schengen (misalnya, nama dan alamat hotel atau akomodasi) ke OpenAI, penyedia teknologi AI yang digunakan untuk menghasilkan itinerary Anda.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Data yang dikirim ke OpenAI semata-mata digunakan untuk menghasilkan rekomendasi itinerary yang dipersonalisasi sesuai dengan preferensi perjalanan Anda dan tidak akan digunakan untuk tujuan lain oleh OpenAI atau pihak ketiga.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                            .padding(.bottom)
                        
                        Text("4.⁠ ⁠Keamanan Data")
                            .font(.custom("Inter-Bold", size: 16))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Kami telah menerapkan langkah-langkah keamanan teknis dan administratif yang memadai untuk melindungi data Anda dari akses yang tidak sah, pengungkapan, atau penyalahgunaan. Namun, tidak ada metode transmisi data melalui internet atau penyimpanan elektronik yang sepenuhnya aman. Oleh karena itu, Anda disarankan untuk menjaga keamanan perangkat Anda.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                            .padding(.bottom)
                        
                        Text("5.⁠ ⁠Hak Anda")
                            .font(.custom("Inter-Bold", size: 16))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Anda memiliki hak-hak berikut terkait data pribadi Anda:")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Akses: Anda dapat melihat dan mengakses data yang telah Anda unggah dan simpan di aplikasi kapan saja.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Penghapusan: Anda dapat menghapus data pribadi yang tersimpan di perangkat Anda kapan saja.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Pembatasan: Anda dapat memilih untuk tidak menggunakan fitur AI Itinerary Generator jika tidak ingin alamat tempat tinggal Anda dikirimkan ke pihak ketiga.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                            .padding(.bottom)
                        
                        Text("6.⁠ ⁠Perubahan pada Kebijakan Privasi")
                            .font(.custom("Inter-Bold", size: 16))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Kebijakan Privasi ini dapat diperbarui dari waktu ke waktu untuk mencerminkan perubahan pada layanan kami atau peraturan privasi yang berlaku. Jika ada perubahan signifikan, kami akan memberi tahu Anda melalui pembaruan aplikasi atau notifikasi.")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                            .padding(.bottom)
                        
                        Text("7.⁠ ⁠Hubungi Kami")
                            .font(.custom("Inter-Bold", size: 16))
                            .foregroundStyle(Color.blackOpacity4)
                        Text("Jika Anda memiliki pertanyaan lebih lanjut mengenai Kebijakan Privasi ini atau ingin memahami lebih lanjut bagaimana data Anda digunakan, silakan hubungi kami melalui:")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.blackOpacity4)
                    }
                }
            }
            .padding(.horizontal, 20)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Kebijakan Privasi")
                        .foregroundStyle(Color.blackOpacity5)
                        .font(Font.custom("Inter-SemiBold", size: 24))
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .foregroundStyle(Color.blackOpacity5)
                            .imageScale(.medium)
                            .fontWeight(.semibold)
                            .background(
                                Circle()
                                    .stroke(Color.blackOpacity2, lineWidth: 1)
                                    .frame(width: 40, height: 40)
                            )
                    }
                    .padding(.leading)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
