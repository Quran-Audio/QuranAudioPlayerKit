//
//  NavigatorView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 28/01/22.
//

import SwiftUI

struct NavigatorView<LeftItems,RightItems>: ViewModifier where LeftItems : View,
                                                                 RightItems : View  {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var showBackButton:Bool = false
    @State var title:String = ""
    @ViewBuilder var leftItems:LeftItems
    @ViewBuilder var rightItems:RightItems
    
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            VStack(spacing: 0) {
                baseNaviator
                content
            }
            .navigationBarHidden(true)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
        } else {
            NavigationView {
                VStack(spacing: 0) {
                    baseNaviator
                    content
                }
                .navigationBarHidden(true)
                .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
            }
            .navigationBarHidden(true)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    @ViewBuilder private var baseNaviator: some View {
        VStack {
            HStack {
                if showBackButton {
                    backButton
                }
                leftItems
                Spacer()
                titleSection
                Spacer()
                rightItems
            }
            .padding()
            .accentColor(ThemeService.whiteColor)
            .foregroundColor(ThemeService.whiteColor)
            .frame(height: 55)
        }.background(ThemeService.themeColor.ignoresSafeArea(edges:.all))
        
    }
}

extension NavigatorView {
    @ViewBuilder private var backButton: some View {
        Button {
            self.mode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.title)
                .font(.system(size: 20))
        }
    }
    
    @ViewBuilder private var titleSection: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            Spacer()
        }
    }
}


//MARK: View Extension
extension View {
    func navigatorView<LeftItems,RightItems>(title:String,
                                             showBackButton:Bool = false,
                                             @ViewBuilder leftItems: () -> LeftItems,
                                             @ViewBuilder rightItems:() -> RightItems) -> some View where LeftItems: View,RightItems : View {

        modifier(NavigatorView(showBackButton: showBackButton,
                                 title: title,
                                 leftItems: leftItems,
                                 rightItems: rightItems))
    }
}
