//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 12/02/22.
//

import SwiftUI

extension View {
    public func deviceNavigationViewStyle() -> AnyView {
        if TargetDevice.currentDevice == .nativeMac {
            return AnyView(self.navigationViewStyle(DefaultNavigationViewStyle()))
        } else {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        }
    }
}

