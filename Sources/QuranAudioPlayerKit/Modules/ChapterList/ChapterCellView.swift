//
//  ChapterCellView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

public struct ChapterCell:View {
    @State var showSwipeButtons:Bool = false
    var onFavourite:(ChapterModel) -> Void = { _ in }
    var onDownload:(ChapterModel) -> Void = { _ in }
    
    var chapter:ChapterModel
    public var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(ThemeService.borderColor,lineWidth: 2)
                        .frame(height: 55)
                    HStack {
                        ZStack {
                            Circle()
                                .strokeBorder(ThemeService.borderColor, lineWidth: 3)
                                .background(Circle().fill(ThemeService.titleColor.opacity(0.8)))
                                .frame(width: 40, height: 40)
                                .cornerRadius(5)
                                .foregroundColor(ThemeService.themeColor)
                            
                            Text("\(chapter.index)")
                                .foregroundColor(ThemeService.whiteColor)
                                .font(.system(size: 19))
                        }
                        VStack(alignment:.leading) {
                            Text("سورَة \(chapter.name)")
                                .font(ThemeService.shared.arabicFont(size: 20))
                                .foregroundColor(ThemeService.titleColor)
                            Text("Surah \(chapter.nameTrans)")
                                .font(ThemeService.shared.translationFont(size: 15))
                                .foregroundColor(ThemeService.subTitleColor)
                                .offset(y:-3)
                        }
                        Spacer()
                        Button {
                            showSwipeButtons.toggle()
                        } label: {
                            Image("more")
                                .resizable()
                                .frame(width: 25 , height: 25)
                                .tint(ThemeService.titleColor)
                        }
                        
                    }
                    .padding(.horizontal,7)
                }
                .offset(x: showSwipeButtons ? -88 : 0)
                .animation(.spring(dampingFraction: 0.5),
                           value: showSwipeButtons)
            }
            if showSwipeButtons {
                HStack(spacing:0){
                    ZStack {
                        Rectangle()
                            .fill(ThemeService.themeColor.opacity(0.8))
                            .frame(width: 44, height: 44)
                        Button {
                            onDownload(chapter)
                            showSwipeButtons.toggle()
                        } label: {
                            let isDownloaded = DataService.shared.isDownloaded(index: chapter.index)
                            Image(systemName: isDownloaded ? "checkmark.icloud.fill" : "icloud.and.arrow.down")
                        }
                    }
                    ZStack {
                        Rectangle()
                            .fill(ThemeService.themeColor.opacity(0.7))
                            .frame(width: 44, height: 44)
                        Button {
                            onFavourite(chapter)
                            showSwipeButtons.toggle()
                        } label: {
                            let isFavourite = DataService.shared.isFavourite(index: chapter.index)
                            Image(systemName: isFavourite ? "star.fill": "star")
                        }
                    }
                }.foregroundColor(ThemeService.whiteColor)
            }
            
        }.foregroundColor(ThemeService.titleColor)
            .padding(.horizontal,7)
    }
}

struct ChapterCell_Previews: PreviewProvider {
    static var previews: some View {
        ChapterCell(chapter:ChapterModel(index: 1,
                                         name: "ٱلْفَاتِحَة",
                                         nameTrans: "Al-Fatihah",
                                         fileName: "000_Al_Fattiha.mp3",
                                         size: "768Kb",
                                         durationInSecs: 98))
    }
}

