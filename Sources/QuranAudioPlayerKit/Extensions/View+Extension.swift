//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 12/02/22.
//

import SwiftUI

extension View {
    public func deviceNavigationViewStyle() -> AnyView {
        if TargetDevice.currentDevice == .iPad {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self.navigationViewStyle(DefaultNavigationViewStyle()))
        }
    }
}

