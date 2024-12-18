import SwiftUI
import UIComponentModule

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    @State var isAgree: Bool = false
    @State var navigateToTabBarView: Bool = false
    private let agreementManager = AgreementManager()
    
    var onPrivacyPolicyAccepted: () -> Void
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Terakhir di-update 18/12/2024")
                                .font(.custom("Inter-Medium", size: 16))
                                .foregroundStyle(Color.black.opacity(0.7))
                                .padding(.bottom)
                            
                            PrivacyPolicy
                                .lineSpacing(4)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color.black.opacity(0.1))
                                .frame(width: .infinity, height: 37)
                            
                            Text("idservisa@gmail.com")
                                .font(.custom("Inter-Bold", size: 14))
                                .foregroundStyle(Color.black.opacity(0.7))
                        }
                        .padding(.bottom, 36)
                        
                        AgreementCheckbox
                        
                        CustomButton(
                            text: "Terima dan lanjut",
                            textColor: .white,
                            color: isAgree ? .blue : .gray,
                            font: "Inter-SemiBold",
                            fontSize: 16
                        ) {
                            agreementManager.setAgreed()
                            onPrivacyPolicyAccepted()
                            withAnimation(.easeInOut) {
                                navigateToTabBarView = true
                            }
                        }
                        .disabled(!isAgree)
                    }
                }
                .padding(.horizontal, 20)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Kebijakan Privasi")
                            .foregroundStyle(Color.black.opacity(0.7))
                            .font(.custom("Inter-SemiBold", size: 24))
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .foregroundStyle(Color.black.opacity(0.7))
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(
                                    Circle()
                                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                )
                        }
                    }
                }
                .navigationDestination(isPresented: $navigateToTabBarView) {
                    TabBarView()
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
    
    private var PrivacyPolicy: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Visaku menghargai privasi Anda dan berkomitmen untuk melindungi data pribadi Anda.")
                .font(.custom("Inter-Regular", size: 14))
                .foregroundStyle(Color.blackOpacity4)
            Text("Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi Anda ketika menggunakan aplikasi Visaku. Harap baca Kebijakan Privasi ini dengan seksama untuk memahami bagaimana kami mengelola data pribadi Anda.")
                .font(.custom("Inter-Regular", size: 14))
                .foregroundStyle(Color.blackOpacity4)
                .padding(.bottom)
            
            Text("1.⁠ ⁠Informasi yang Dibutuhkan untuk Menjalankan Layanan dalam Aplikasi Visaku")
                .font(.custom("Inter-Bold", size: 16))
                .foregroundStyle(Color.blackOpacity4)
            Text("Aplikasi Visaku mengumpulkan informasi yang diperlukan untuk menyediakan layanan, yang dapat dibagi menjadi dua kategori:")
                .font(.custom("Inter-Regular", size: 14))
                .foregroundStyle(Color.blackOpacity4)
            Text("**Data Identitas**: Informasi yang diambil dari KTP, paspor, atau dokumen lain yang Anda unggah melalui aplikasi untuk pengisian otomatis formulir visa. Informasi ini dapat mencakup nama, tanggal lahir, nomor paspor, alamat, dan kewarganegaraan.")
                .font(.custom("Inter-Regular", size: 14))
                .foregroundStyle(Color.blackOpacity4)
            Text("**Data Penggunaan**: Informasi teknis mengenai cara Anda menggunakan aplikasi, seperti fitur yang sering Anda gunakan, interaksi dengan antarmuka, serta preferensi Anda.")
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
            Text("**Akses**: Anda dapat melihat dan mengakses data yang telah Anda unggah dan simpan di aplikasi kapan saja.")
                .font(.custom("Inter-Regular", size: 14))
                .foregroundStyle(Color.blackOpacity4)
            Text("**Penghapusan**: Anda dapat menghapus data pribadi yang tersimpan di perangkat Anda kapan saja.")
                .font(.custom("Inter-Regular", size: 14))
                .foregroundStyle(Color.blackOpacity4)
            Text("**Pembatasan**: Anda dapat memilih untuk tidak menggunakan fitur AI Itinerary Generator jika tidak ingin alamat tempat tinggal Anda dikirimkan ke pihak ketiga.")
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
    
    private var AgreementCheckbox: some View {
        HStack(alignment: .top) {
            Image(systemName: isAgree ? "checkmark.rectangle.fill" : "rectangle")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundStyle(Color.blue)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                (Text("Dengan menggunakan aplikasi Visaku, Anda menyetujui ")
                    .foregroundStyle(Color.black.opacity(0.7))
                + Text("**pengumpulan**")
                    .foregroundStyle(Color.blue)
                + Text(", ")
                    .foregroundStyle(Color.black.opacity(0.7))
                + Text("**penggunaan**")
                    .foregroundStyle(Color.blue)
                + Text(", dan ")
                    .foregroundStyle(Color.black.opacity(0.7))
                + Text("**pemrosesan data pribadi Anda**")
                    .foregroundStyle(Color.blue)
                + Text(" sesuai dengan ketentuan dalam ")
                    .foregroundStyle(Color.black.opacity(0.7))
                + Text("**Kebijakan Privasi Visaku**")
                    .foregroundStyle(Color.blue)
                + Text(".")
                    .foregroundStyle(Color.black.opacity(0.7)))
            }
            .font(.custom("Inter-Regular", size: 14))
            .lineSpacing(4)
        }
        .padding(.bottom, 36)
        .onTapGesture {
            isAgree.toggle()
        }
    }
}

//#Preview {
//    NavigationStack {
////        PrivacyPolicyView(onPrivacyPolicyAccepted: true)
//    }
//}
