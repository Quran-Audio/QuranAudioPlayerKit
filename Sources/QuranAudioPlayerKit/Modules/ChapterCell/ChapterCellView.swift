//
//  ChapterCellView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

public struct ChapterCell:View {
    @ObservedObject var viewModel:ChapterCellViewModel
    
    public init(chapter:ChapterModel) {
        viewModel = ChapterCellViewModel(chapter: chapter)
    }
    
    public var body: some View {
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
                        
                        Text("\(viewModel.chapter.index)")
                            .foregroundColor(Color(UIColor.label.withAlphaComponent(0.5)))
                            .font(.system(size: 17))
                    }
                    VStack(alignment:.leading, spacing: 5) {
                        Text(viewModel.chapter.name)
                            .font(ThemeService.shared.arabicFont(size: 17))
                            .foregroundColor(Color(UIColor.label))
                        Text(viewModel.chapter.nameTrans)
                            .font(.system(size: 15))
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    Spacer()
                    if viewModel.isCurrentChapter {
                        Image(systemName: "waveform")
                            .font(.system(size: 20))
                            .frame(width: 60, height: 70)
                            .foregroundColor(ThemeService.themeColor)
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            
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
        }
    }
}

