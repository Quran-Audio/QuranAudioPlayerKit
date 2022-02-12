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
                        .foregroundColor(Color(uiColor: .tertiarySystemBackground))
                    Rectangle().frame(width:geometry.size.width * viewModel.sliderValue, height: 5)
                        .foregroundColor(ThemeService.themeColor)
                }
                .frame(height: 5)
            }
            
            HStack {
                Text("\(viewModel.currentChapter?.index ?? 0)")
                    .font(.system(size: 17))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .frame(width: 30, height: 70, alignment: .center)
                HStack {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(viewModel.currentChapter?.name ?? "")")
                                .foregroundColor(Color(uiColor: .label))
                                .font(ThemeService.shared.arabicFont(size: 17))
                            Text("\(viewModel.currentChapter?.nameTrans ?? "")")
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                                .font(ThemeService.shared.translationFont(size: 15))
                        }
                    }
                    Spacer(minLength: 8)
                }
                ZStack {
                    if viewModel.isBuffering {
                        LoaderView()
                    }
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(ThemeService.themeColor)
                        .font(.system(size: 25))
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            viewModel.playPause()
                        }
                }
                .padding(10)
            }
            .background(ThemeService.indigo.opacity(0.5))
            .frame(height: 70)
        }
        .onAppear(perform: {
            viewModel.subscribeAudioNotification()
        }).onDisappear(perform: {
            viewModel.unSubscribeAudioNotification()
        })
    }
    
    @ViewBuilder private var titleBox: some View {
        HStack(spacing:0) {
            Rectangle().frame(width: 50,height: 50)
                .foregroundColor(ThemeService.themeColor)
            //            Rectangle().frame(width: 1,height: 50)
            //                .foregroundColor(ThemeService.whiteColor)
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

