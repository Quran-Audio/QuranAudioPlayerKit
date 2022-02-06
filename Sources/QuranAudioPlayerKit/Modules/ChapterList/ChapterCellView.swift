//
//  ChapterCellView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

public struct ChapterCell:View {
    @ObservedObject var viewModel = ChapterListViewModel()
    @State var showSwipeButtons:Bool = false
    var onFavourite:(ChapterModel) -> Void = { _ in }
    var onDownload:(ChapterModel) -> Void = { _ in }
    
    var chapter:ChapterModel
    public var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                ZStack {
                    Rectangle()
                        .fill(ThemeService.themeColor.opacity(0.1))
                        .frame(height: 70)
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(ThemeService.themeColor.opacity(0.2))
                                .frame(width: 40, height: 70, alignment: .leading)
                            
                            Text("\(chapter.index)")
                                .foregroundColor(Color(UIColor.label.withAlphaComponent(0.5)))
                                .font(.system(size: 17))
                        }
                        VStack(alignment:.leading) {
                            Text("سورَة \(chapter.name)")
                                .font(ThemeService.shared.arabicFont(size: 20))
                                .foregroundColor(Color(UIColor.label))
                            Text("Surah \(chapter.nameTrans)")
                                .font(.system(size: 15))
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        Spacer()
                        Button {
                            viewModel.setCurrent(chapter: chapter)
//                            showSwipeButtons.toggle()
                        } label: {
                            Image(systemName: (chapter.isPlaying ?? false) ? "play.fill" : "play")
                                .font(.system(size: 20))
                                .frame(width: 60, height: 70)
                                .foregroundColor(ThemeService.themeColor)
                        }
                    }
                }
                .background(Color(UIColor.systemBackground))
//                .offset(x: showSwipeButtons ? -88 : 0)
//                .animation(.spring(dampingFraction: 0.5),
//                           value: showSwipeButtons)
            }
//            if showSwipeButtons {
//                HStack(spacing:0){
//                    ZStack {
//                        Rectangle()
//                            .fill(ThemeService.themeColor.opacity(0.8))
//                            .frame(width: 44, height: 44)
//                        Button {
//                            onDownload(chapter)
//                            showSwipeButtons.toggle()
//                        } label: {
//                            let isDownloaded = DataService.shared.isDownloaded(index: chapter.index)
//                            Image(systemName: isDownloaded ? "checkmark.icloud.fill" : "icloud.and.arrow.down")
//                        }
//                    }
//                    ZStack {
//                        Rectangle()
//                            .fill(ThemeService.themeColor.opacity(0.7))
//                            .frame(width: 44, height: 44)
//                        Button {
//                            onFavourite(chapter)
//                            showSwipeButtons.toggle()
//                        } label: {
//                            let isFavourite = DataService.shared.isFavourite(index: chapter.index)
//                            Image(systemName: isFavourite ? "star.fill": "star")
//                        }
//                    }
//                }.foregroundColor(ThemeService.whiteColor)
//            }
            
        }.foregroundColor(ThemeService.themeColor)
            .padding(.horizontal,7)
    }
}

struct ChapterCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChapterCell(chapter:ChapterModel(index: 1,
                                             name: "ٱلْفَاتِحَة",
                                             nameTrans: "Al-Fatihah",
                                             fileName: "000_Al_Fattiha.mp3",
                                             size: "768Kb",
                                             durationInSecs: 98))
            ChapterCell(chapter:ChapterModel(index: 1,
                                             name: "ٱلْفَاتِحَة",
                                             nameTrans: "Al-Fatihah",
                                             fileName: "000_Al_Fattiha.mp3",
                                             size: "768Kb",
                                             durationInSecs: 98))
                .preferredColorScheme(.dark)
        }
    }
}

