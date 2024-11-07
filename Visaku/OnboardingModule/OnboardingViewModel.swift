import SwiftUI

@Observable
class OnboardingViewModel {
    var showTabBarView: Bool = false
    var timeline: Int = 1
    
    func getOnboardingTitle(index: Int) -> String {
        switch index {
        case 1:
            return "Traveling mudah dengan Visaku"
        case 2:
            return "Scan, form terisi automatis!"
        case 3:
            return "Itinerary selesai hitungan detik"
        case 4:
            return "Foto langsung sesuai standar"
        case 5:
            return "Visaku bantu cek dokumenmu"
        default:
            return "error"
        }
    }
    
    func getOnboardingCaption(index: Int) -> String {
        switch index {
        case 1:
            return " "
        case 2:
            return "Gak perlu lagi ribet isi form sendiri!"
        case 3:
            return "Tada! AI bisa bantu kamu buat dokumen itinerary"
        case 4:
            return "Visaku beri feedback saat foto"
        case 5:
            return "Gak takut ketinggalan dokumen"
        default:
            return "error"
        }
    }
    
    func getOnboardingTextColor(index: Int) -> Color {
        switch index {
        case 1:
            return Color(red: 0.93, green: 0.98, blue: 0.98)
        case 2:
            return Color(red: 0.2, green: 0.63, blue: 0.71)
        case 3:
            return Color(red: 0.8, green: 0.93, blue: 0.93)
        case 4:
            return Color(red: 0.4, green: 0.53, blue: 0.53)
        case 5:
            return Color(red: 0.93, green: 0.98, blue: 0.98)
        default:
            return Color(red: 0.93, green: 0.98, blue: 0.98)
        }
    }

}
