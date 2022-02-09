//
//  SwiftUIView.swift
//
//  Created by Mohammed Shafeer on 11/01/22.
//

import SwiftUI

struct FullPlayerView: View {
    @ObservedObject private var viewModel = FullPlayerViewModel()
    @Binding var showFullPlayer: Bool
    
    var body: some View {
        VStack (alignment: .center, spacing: 20) {
            HStack {
                Spacer()
                Button {
                    showFullPlayer.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .padding()
                        .background(Color(uiColor: .tertiaryLabel).opacity(0.7))
                        .foregroundColor(Color(uiColor: .label))
                        .clipShape(Circle())
                }
            }.padding()
            GeometryReader { geo in
                Image(systemName: "sparkles")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .foregroundColor(ThemeService.themeColor.opacity(0.3))
            }
            
            TitleView(viewModel: FullPlayerViewModel())
            SliderView(viewModel: FullPlayerViewModel())
            ButtonView(viewModel: FullPlayerViewModel())
           
            Spacer()
        }
        .background(Color(uiColor: .systemBackground))
        
        .onAppear(perform: {
            viewModel.subscribeAudioNotification()
        }).onDisappear(perform: {
            viewModel.unSubscribeAudioNotification()
        })
    }
}

struct TitleView: View {
    @ObservedObject var viewModel:FullPlayerViewModel
    var body: some View {
       
        VStack(alignment:.center, spacing: 10) {
            Text("سورَة \(viewModel.chapterName)")
                .font(.system(.title))
                .foregroundColor(Color(uiColor: .label))
            Text("Surah \(viewModel.chapterNameTrans)")
                .font(.system(.title3))
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
        .padding()
        .frame(maxWidth:.infinity)
    }
}

struct ButtonView: View {
    @ObservedObject var viewModel:FullPlayerViewModel
    var body: some View {
        Group {
            HStack {
                Image(systemName: "backward")
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .font(.system(size: 25))
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        viewModel.onPrevoius()
                    }
                Image(systemName: "gobackward.10")
                    .foregroundColor(Color(uiColor: .label))
                    .font(.system(size: 25))
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        //TODO: Not working properly - Need to fix
                        viewModel.seekTo(
                            seconds: CGFloat(viewModel.currentChapter?.durationInSecs ?? 0 - 10))
                    }
                Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .foregroundColor(ThemeService.themeColor)
                    .font(.system(size: 60))
                    .frame(width: 80, height: 80)
                    .onTapGesture {
                        viewModel.playPause()
                    }
                Image(systemName: "goforward.10")
                    .foregroundColor(Color(uiColor: .label))
                    .font(.system(size: 25))
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        //TODO: Not working properly - Need to fix
                        viewModel.seekTo(
                            seconds: CGFloat(viewModel.currentChapter?.durationInSecs ?? 0 + 10))
                    }
                Image(systemName: "forward")
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .font(.system(size: 25))
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        viewModel.onNext()
                    }
            }
        }
    }
}

struct SliderView: View {
    @StateObject var viewModel:FullPlayerViewModel
    @State var sliderVal:Double = 50
    var body: some View {
        VStack(spacing:20) {
            Slider(value: $viewModel.sliderValue,
                   in: 0...viewModel.sliderMaxValue){ isEdited in
                viewModel.seekTo(seconds: viewModel.sliderValue)
            }
                   .accentColor(ThemeService.themeColor)
                   .padding(.horizontal)
            HStack() {
                Text("\(viewModel.currentTimeText)")
                Spacer()
                Text("\(viewModel.durationText)")
            }
            .foregroundColor(Color(uiColor: .secondaryLabel))
            .font(.system(size: 16))
            .offset(y: -10)
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

struct FullPlayerView_Previews: PreviewProvider {
    @State private static var showFullPlayer = true
    static var previews: some View {
        Group {
            FullPlayerView(showFullPlayer: $showFullPlayer)
                .previewDevice("iPhone 13 mini")
            FullPlayerView(showFullPlayer: $showFullPlayer)
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 13 mini")
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
