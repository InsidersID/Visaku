import SwiftUI

extension Font {
    enum CustomFont: String {
        // Inter Fonts
        case interBlack = "Inter-Black"
        case interBlackItalic = "Inter-BlackItalic"
        case interBold = "Inter-Bold"
        case interBoldItalic = "Inter-BoldItalic"
        case interExtraBold = "Inter-ExtraBold"
        case interExtraBoldItalic = "Inter-ExtraBoldItalic"
        case interExtraLight = "Inter-ExtraLight"
        case interExtraLightItalic = "Inter-ExtraLightItalic"
        case interItalic = "Inter-Italic"
        case interLight = "Inter-Light"
        case interLightItalic = "Inter-LightItalic"
        case interMedium = "Inter-Medium"
        case interMediumItalic = "Inter-MediumItalic"
        case interRegular = "Inter-Regular"
        case interSemiBold = "Inter-SemiBold"
        case interSemiBoldItalic = "Inter-SemiBoldItalic"
        case interThin = "Inter-Thin"
        case interThinItalic = "Inter-ThinItalic"
        
        // Poppins Fonts
        case poppinsBlack = "Poppins-Black"
        case poppinsBlackItalic = "Poppins-BlackItalic"
        case poppinsBold = "Poppins-Bold"
        case poppinsBoldItalic = "Poppins-BoldItalic"
        case poppinsExtraBold = "Poppins-ExtraBold"
        case poppinsExtraBoldItalic = "Poppins-ExtraBoldItalic"
        case poppinsExtraLight = "Poppins-ExtraLight"
        case poppinsExtraLightItalic = "Poppins-ExtraLightItalic"
        case poppinsItalic = "Poppins-Italic"
        case poppinsLight = "Poppins-Light"
        case poppinsLightItalic = "Poppins-LightItalic"
        case poppinsMedium = "Poppins-Medium"
        case poppinsMediumItalic = "Poppins-MediumItalic"
        case poppinsRegular = "Poppins-Regular"
        case poppinsSemiBold = "Poppins-SemiBold"
        case poppinsSemiBoldItalic = "Poppins-SemiBoldItalic"
        case poppinsThin = "Poppins-Thin"
        case poppinsThinItalic = "Poppins-ThinItalic"
        
        var name: String {
            return self.rawValue
        }
        
        func size(_ fontSize: CGFloat) -> Font {
            return Font.custom(self.name, size: fontSize)
        }
    }
}