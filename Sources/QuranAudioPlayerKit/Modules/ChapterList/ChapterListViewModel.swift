//
//  ChapterListViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import Combine
import Foundation
import CoreGraphics

class ChapterListViewModel: ObservableObject {
    @Published var currentChapter:ChapterModel?
    @Published var isBuffering:Bool = false
    @Published var listType:EListType = .all {
        didSet {
            print("Set from data")
        }
    }
    var shareText: String {
        return "App to Listen Quran Arabic and malayalam translation\n Url: "
    }
    var isPlaying:Bool {AudioService.shared.isPlaying}
    var chapterName:String {currentChapter?.name ?? ""}
    var sliderCurrentValue: CGFloat{AudioService.shared.currentTimeInSecs}
    var sliderMaxValue: CGFloat{CGFloat(currentChapter?.durationInSecs ?? 0)}
    var currentTimeText:String {AudioService.shared.currentTimeText}
    var durationText:String {AudioService.shared.durationText(secs: currentChapter?.durationInSecs ?? 0)}
    var baseUrl:String {DataService.shared.baseUrl}
    var chapterList:[ChapterModel] {DataService.shared.chapterList}
    
    func favouriteImage(chapter:ChapterModel) -> String {
        if isFavourite(chapter: chapter) {
            return "star"
        }
        return "star.slash"
    }
    
    func downloadImage(chapter:ChapterModel) -> String {
        if DataService.shared.isInDownloadQueue(index: chapter.index) {
            return "arrow.clockwise.icloud"
        } else if isDownloaded(chapter: chapter) {
            return "checkmark.icloud"
        }else {
            return "icloud.and.arrow.down"
        }
    }
    
    var chapters:[ChapterModel] {
        switch listType {
        case .all:
            return chapterList
        case .downloads:
            let downloads = DataService.shared.getDownloads()
            return chapterList.filter({ chapter in
                downloads.contains(chapter.index)
            })
        case .favourites:
            let favourites = DataService.shared.getFavourites()
            return chapterList.filter({ chapter in
                favourites.contains(chapter.index)
            })
        }
    }
        
    init() {
        print("initiated")
        self.currentChapter = AudioService.shared.loadChapter()
    }
}

//MARK: Audio
extension ChapterListViewModel {
    func setCurrent(chapter:ChapterModel) {
        self.currentChapter = chapter
        configureAudio()
        playPause()
    }
    
    //MARK: play and seek
    func playPause() {
        AudioService.shared.playPause()
        currentChapter?.isPlaying = AudioService.shared.isPlaying
    }
    
    func seekTo(seconds:CGFloat) {
        AudioService.shared.seekTo(seconds: seconds)
        currentChapter?.isPlaying = AudioService.shared.isPlaying
    }
    
    func configureAudio() {
        guard let chapter = currentChapter else {return}
        AudioService.shared.setModel(baseUrl: baseUrl, model: chapter)
    }
}

//MARK: Favourite
extension ChapterListViewModel {
    func onFavouriteChapter(chapterIndex:Int) {
        if DataService.shared.isFavourite(index: chapterIndex) {
            DataService.shared.removeFavourite(chapterIndex: chapterIndex)
        }else {
            DataService.shared.setFavourite(index: chapterIndex)
        }
        //self.listType = self.listType
    }
    
    func isFavourite(chapter:ChapterModel) -> Bool {
        DataService.shared.isFavourite(index: chapter.index)
    }
}

//MARK: Download
extension ChapterListViewModel {
    func addToDownloadQueue(chapter:ChapterModel) {
        if DataService.shared.isInDownloadQueue(index: chapter.index) {
            DataService.shared.removeFromDownloadQueue(index: chapter.index)
        }else {
            DataService.shared.addToDownloadQueue(index:chapter.index)
        }
    }
    
    func deleteChapter(chapter:ChapterModel) {
        if DataService.shared.isDownloaded(index: chapter.index) {
            DataService.shared.deleteDownloaded(chapter: chapter)
        }
    }
    
    func isDownloaded(chapter:ChapterModel) -> Bool {
        DataService.shared.isDownloaded(index: chapter.index)
    }
}

enum EListType {
    case all
    case downloads
    case favourites
}
