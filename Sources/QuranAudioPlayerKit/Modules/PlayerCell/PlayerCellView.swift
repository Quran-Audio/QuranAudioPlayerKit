//
//  PlayerCellView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct PlayerCellView: View {
    @ObservedObject var viewModel:PlayerCellViewModel
    
    var body: some View {
        VStack(spacing:0) {
            ZStack(alignment:.leading) {
                GeometryReader { geometry in
                    Rectangle().frame(height: 5)
                        .foregroundColor(ThemeService.borderColor)
                    Rectangle().frame(width:geometry.size.width * viewModel.sliderValue,height: 5)
                        .foregroundColor(ThemeService.indigo)
                }.frame(height: 5)
            }
            HStack {
                ZStack {
                    titleBox
                    ZStack {
                        if viewModel.isPlaying {
                            Image(systemName: "speaker.wave.2")
                                .foregroundColor(ThemeService.whiteColor)
                                .font(.system(size: 25))
                        }else {
                            Text("\(viewModel.currentChapter?.index ?? 0)")
                                .font(.system(size: 25))
                                .foregroundColor(ThemeService.whiteColor)
                        }
                    }
                }
                HStack {
                    HStack {
                        VStack(alignment:.leading) {
                            VStack(alignment: .leading,spacing: 0) {
                                Text("سورَة \(viewModel.currentChapter?.name ?? "")")
                                    .foregroundColor(ThemeService.whiteColor)
                                    .font(ThemeService.shared.arabicFont(size: 23).bold())
                                .offset(y:3)
                                
                                Text("Surah \(viewModel.currentChapter?.nameTrans ?? "")")
                                    .foregroundColor(ThemeService.whiteColor.opacity(0.7))
                                    .font(ThemeService.shared.translationFont(size: 15))
                                    .offset(y:-3)
                            }
                        }
                        Spacer(minLength: 10)
                    }
                    ZStack {
                        if viewModel.isBuffering {
                            LoaderView()
                        }
                        Image(systemName: viewModel.isPlaying ? "pause" : "play")
                            .foregroundColor(ThemeService.whiteColor)
                            .font(.system(size: 30))
                            .frame(width: 40,height: 40).onTapGesture {
                                viewModel.playPause()
                            }
                        
                    }
                }
            }
            .background(ThemeService.themeColor)
            
        }
        .onAppear(perform: {
            viewModel.subscribeAudioNotification()
        }).onDisappear(perform: {
            viewModel.unSubscribeAudioNotification()
        })
        .frame(height: 59)
    }
    
    @ViewBuilder private var titleBox: some View {
        HStack(spacing:0) {
            Rectangle().frame(width: 50,height: 50)
                .foregroundColor(ThemeService.themeColor)
            Rectangle().frame(width: 1,height: 50)
                .foregroundColor(ThemeService.whiteColor)
        }
    }
    
    struct LoaderView:View {
        var tintColor:Color = .black
        var scaleSize:CGFloat = 1.5
        
        var body: some View {
            ProgressView()
                .scaleEffect(scaleSize,anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: ThemeService.whiteColor))
        }
    }
}

