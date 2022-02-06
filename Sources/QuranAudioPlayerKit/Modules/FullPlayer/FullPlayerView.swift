//
//  PlayerView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 10/01/22.
//

import SwiftUI

struct FullPlayerView: View {
    @ObservedObject private var viewModel = FullPlayerViewModel()
    @Binding var frameHeight:CGFloat
    @Binding var opacity:CGFloat
    
    var body: some View {
        VStack(spacing:10){
            Spacer()
            closeButton
            TitleView(viewModel: viewModel)
            ButtonView(viewModel: viewModel)
            SliderView(viewModel: viewModel)
            Divider()
        }
        .onAppear(perform: {
            viewModel.subscribeAudioNotification()
        }).onDisappear(perform: {
            viewModel.unSubscribeAudioNotification()
        })
        .background(ThemeService.themeColor)
        .frame(height: frameHeight)
        .cornerRadius(radius: 20,corners:[.topLeft,.topRight])
        .animation(.spring(dampingFraction: 0.55),value: frameHeight)
        .opacity(opacity)
        .shadow(color: ThemeService.whiteColor.opacity(0.2),
                radius: 1,
                x: 0,
                y: -1)
    }
    
    @ViewBuilder var closeButton: some View {
        Button {
            frameHeight = 0
            withAnimation(.easeIn(duration: 2)) {
                opacity = 0
            }
        } label: {
            Image(systemName: "chevron.down")
                .font(.system(size: 20))
                .foregroundColor(ThemeService.whiteColor)
        }
        .frame(width: 44, height: 40)
    }
    
    struct TitleView: View {
        @ObservedObject var viewModel:FullPlayerViewModel
        var body: some View {
            VStack(alignment:.center,spacing: 0) {
                Text("سورَة \(viewModel.chapterName)")
                    .font(ThemeService.shared.arabicFont(size: 30))
                    .foregroundColor(ThemeService.whiteColor)
                Text("Surah \(viewModel.chapterNameTrans)")
                    .font(ThemeService.shared.translationFont(size: 20))
                    .foregroundColor(ThemeService.whiteColor.opacity(0.7))
            }.frame(maxWidth:.infinity)
            
        }
    }
    
    struct ButtonView: View {
        @ObservedObject var viewModel:FullPlayerViewModel
        var body: some View {
            HStack(spacing: 30) {
                Button {
                    viewModel.onPrevoius()
                } label: {
                    Image(systemName: "backward")
                }
                .font(.system(size: 20))
                ZStack {
                    if viewModel.isBuffering {
                        LoaderView()
                    }
                    Button {
                        viewModel.playPause()
                    } label: {
                        Image(systemName: viewModel.isPlaying ? "pause" : "play")
                    }
                    .font(.system(size: 40))
                }
                
                Button {
                    viewModel.onNext()
                } label: {
                    Image(systemName: "forward")
                }
                .font(.system(size: 20))
                
            }.offset(y:20)
                .foregroundColor(ThemeService.whiteColor)
        }
    }
    
    struct SliderView: View {
        @StateObject var viewModel:FullPlayerViewModel
        @State var sliderVal:Double = 0
        var body: some View {
            VStack(spacing:20){
                Slider(value: $viewModel.sliderValue,
                       in: 0...viewModel.sliderMaxValue){ isEdited in
                    viewModel.seekTo(seconds: viewModel.sliderValue)
                }
                       .accentColor(ThemeService.whiteColor)
                       .padding(.horizontal)
                       .offset(y:10)
                
                HStack() {
                    Text("\(viewModel.currentTimeText)")
                    Spacer()
                    Text("\(viewModel.durationText)")
                }
                .foregroundColor(ThemeService.whiteColor)
                .font(.system(size: 16))
                .offset(y: -8)
                .padding(.horizontal)
            }
        }
    }
    
    struct LoaderView:View {
        var tintColor:Color = ThemeService.whiteColor
        var scaleSize:CGFloat = 2.5
        
        var body: some View {
            ProgressView()
                .scaleEffect(scaleSize,anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
        }
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {
        
        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
