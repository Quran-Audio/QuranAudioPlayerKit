//
//  ToastView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 27/01/22.
//

import SwiftUI

struct ToastView: ViewModifier {
    @Binding var showToast:Bool
    @Binding var type:ToasType
    var title:String = ""
    var description:String = ""
    var alignment:Alignment = .center
    var duration:CGFloat = 1
    var onConfirm:(() -> Void)?
    
    func body(content:Content) -> some View {
        ZStack(alignment: alignment) {
            content
            if showToast {
                VStack(spacing:10) {
                    HStack {
                        image
                            .font(.system(size: 20))
                        Text(title)
                            .font(.system(size: 20))
                    }
                    if(!description.isEmpty) {
                        Text(description)
                            .font(.system(size: 18))
                            .foregroundColor(ThemeService.whiteColor.opacity(0.7))
                    }
                    if type == .alert {
                        HStack{
                            Button {
                                onConfirm?()
                            } label: {
                                Text("Ok")
                                    .padding(.horizontal)
                                    .frame(height: 40)
                                    .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder())
                                    .foregroundColor(ThemeService.borderColor)
                            }
                            Button {
                                showToast = false
                            } label: {
                                Text("Cancel")
                                    .padding(.horizontal)
                                    .frame(height: 40)
                                    .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder())
                                    .foregroundColor(ThemeService.borderColor)
                            }
                        }
                    }
                }
                .padding()
                .foregroundColor(ThemeService.whiteColor)
                .background(ThemeService.themeColor)
                .cornerRadius(15)
                .shadow(color: ThemeService.themeColor.opacity(0.7),
                        radius: 3, x: 1, y: 1)
                
            }
        }.onChange(of: showToast) { newValue in
            if showToast {
                if type != .alert {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation(.spring()) {
                            showToast = false
                        }
                    }
                }
            }
        }
        
    }
        
    enum ToasType {
        case info,warning,error,alert
    }
    
    @ViewBuilder var image: some View {
        switch type {
        case .info:
            Image(systemName: "info.circle")
        case .warning:
            Image(systemName: "exclamationmark.triangle")
        case .error:
            Image(systemName: "xmark.circle")
        case .alert:
            Image(systemName: "exclamationmark.triangle")
        }
    }
}

extension View {
    func toast(showToast:Binding<Bool>,
               title:String = "",
               description:String = "",
               type:Binding<ToastView.ToasType>,
               duration:Double = 1,
               onConfirm:(() -> Void)? = nil,
               alignment:Alignment = .center) -> some View {
        
        modifier(ToastView(showToast: showToast,
                           type: type,
                           title: title,
                           description: description,
                           alignment: alignment,
                           duration: duration,
                           onConfirm: onConfirm))
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Test")
            Spacer()
            HStack{
                Spacer()
            }
        }.toast(showToast: .constant(true),
                title: "Some Title",
                description: "Some Description",
                type:.constant(.alert),
                alignment: .bottom)
            .background(ThemeService.whiteColor)
        
    }
}

