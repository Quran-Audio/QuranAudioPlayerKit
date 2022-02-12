//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 09/02/22.
//

import Foundation

class ChapterCellViewModel:ObservableObject {
    @Published var statusImage:String?
    
    init(chapter:ChapterModel) {
        self.chapter = chapter
    }
    var chapter:ChapterModel
    
    var isDownloaded:Bool {
        DataService
        .shared
        .isDownloaded(index: chapter.index)
    }
    
    var isCurrentChapter:Bool {
        if let currentChapter = AudioService.shared.loadChapter(){
            return currentChapter.index == chapter.index
        }
        return false
    }
    
    var imageName:String {isCurrentChapter ? "waveform" : ""}
}
