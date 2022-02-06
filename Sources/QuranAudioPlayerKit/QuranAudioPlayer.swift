/** With the name of ALLAH **/

import SwiftUI

@available(iOS 15, macOS 12.0, *)
public struct QuranAudioPlayerKit:View  {

    public init() {
    }
    
    public var body: some View {
        ChapterListView()
    }
    
    public static func registerFonts() {
        QuranAudioPlayerKitFont.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
        }
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider) else {
                fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
        var error: Unmanaged<CFError>?

        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}

public enum QuranAudioPlayerKitFont: String, CaseIterable {
    case regular = "XB Niloofar"
}
