//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 05/02/22.
//

import SwiftUI

public class ThemeService {
    public static let secondaryColor = Color("secondaryColor")
    public static let indigo = Color("indigo")
    public static let green = Color("green")
    public static let yellow = Color("yellow")
    public static let red = Color("red")
    public static let whiteColor = Color(UIColor.systemBackground)
    public static var themeColor = Color("theme")
    public static let subTitleColor = Color("subTitle")
    public static let titleColor = Color("title")
    public static let borderColor = Color("borderColor")
    public static let lableColor = Color(UIColor.label)
        
    public static let shared = ThemeService()
    private init() {}
    
    public func arabicFont(size:CGFloat) -> Font {
//        Font.custom("XB Niloofar", size: size)
        Font.system(size: size)
    }
    
    public func translationFont(size:CGFloat) -> Font {
        Font.system(size: size)
    }
}
