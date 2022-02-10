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
    
    var imageName:String {
        var image = ""
        if isCurrentChapter {
            image = "waveform"
        }
        
        if !isDownloaded {
            image = "icloud.and.arrow.down"
        }
        
        if DataService.shared.isInDownloadQueue(index: chapter.index) {
            image = "arrow.clockwise.icloud"
        }
        
        return image
    }
    
    
}

//MARK: Download Queue
extension ChapterCellViewModel {
    func onAddOrRemoveFromDownloadQueue() {
        if DataService.shared.isInDownloadQueue(index: chapter.index) {
            DataService.shared.removeFromDownloadQueue(index: chapter.index)
        }else {
            DataService.shared.addToDownloadQueue(index:chapter.index)
        }
        
        statusImage = imageName
    }
}
