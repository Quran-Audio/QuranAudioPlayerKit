//
//  ChapterCellView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

public struct ChapterCell:View {
    @ObservedObject var viewModel = ChapterListViewModel()
    var onFavourite:(ChapterModel) -> Void = { _ in }
    var onDownload:(ChapterModel) -> Void = { _ in }
    @Binding var currentChapter:ChapterModel?
    
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
                        VStack(alignment:.leading, spacing: 5) {
                            Text("سورَة \(chapter.name)")
                                .font(ThemeService.shared.arabicFont(size: 17))
                                .foregroundColor(Color(UIColor.label))
                            Text("Surah \(chapter.nameTrans)")
                                .font(.system(size: 15))
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        Spacer()
                        if (currentChapter?.index ?? 0) == chapter.index {
                            Image(systemName: "waveform")
                                .font(.system(size: 20))
                                .frame(width: 60, height: 70)
                                .foregroundColor(ThemeService.themeColor)
                        }else {
                            Color.clear
                        }
                    }
                }
                .background(Color(UIColor.systemBackground))
            }
            
        }.foregroundColor(ThemeService.themeColor)
            .padding(.horizontal,7)
    }
}

struct ChapterCell_Previews: PreviewProvider {
    let chapter  = ChapterModel(index: 1,
                                name: "ٱلْفَاتِحَة",
                                nameTrans: "Al-Fatihah",
                                fileName: "000_Al_Fattiha.mp3",
                                size: "768Kb",
                                durationInSecs: 98)
    static var previews: some View {
        Group {
            ChapterCell(currentChapter: .constant(ChapterModel(index: 1,
                                                               name: "ٱلْفَاتِحَة",
                                                               nameTrans: "Al-Fatihah",
                                                               fileName: "000_Al_Fattiha.mp3",
                                                               size: "768Kb",
                                                               durationInSecs: 98)),
                        chapter:ChapterModel(index: 1,
                                             name: "ٱلْفَاتِحَة",
                                             nameTrans: "Al-Fatihah",
                                             fileName: "000_Al_Fattiha.mp3",
                                             size: "768Kb",
                                             durationInSecs: 98))
            ChapterCell(currentChapter: .constant(ChapterModel(index: 1,
                                                               name: "ٱلْفَاتِحَة",
                                                               nameTrans: "Al-Fatihah",
                                                               fileName: "000_Al_Fattiha.mp3",
                                                               size: "768Kb",
                                                               durationInSecs: 98)),
                        chapter:ChapterModel(index: 1,
                                             name: "ٱلْفَاتِحَة",
                                             nameTrans: "Al-Fatihah",
                                             fileName: "000_Al_Fattiha.mp3",
                                             size: "768Kb",
                                             durationInSecs: 98))
        }
    }
}

