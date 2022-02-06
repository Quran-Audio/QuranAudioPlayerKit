//
//  PlayerCellViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 21/01/22.
//

import Foundation
import CoreGraphics

class PlayerCellViewModel:ObservableObject {
    @Published var currentChapter:ChapterModel?
    @Published var isBuffering:Bool = false
    @Published var sliderValue:CGFloat = 0
    var isPlaying:Bool {AudioService.shared.isPlaying}
    var baseUrl:String?
    
    init() {
        subscribeAudioNotification()
        baseUrl = AudioService.shared.loadBaseUrl()
        isBuffering = AudioService.shared.isBuffering
        loadChapter()
    }
    
    func loadChapter() {
        guard let currentChapter = AudioService.shared.loadChapter() else {return}
        self.currentChapter = currentChapter
    }
}

//MARK: play and seek
extension PlayerCellViewModel {
    func playPause() {
        AudioService.shared.playPause()
        currentChapter?.isPlaying = AudioService.shared.isPlaying
    }
    
    func seekTo(seconds:CGFloat) {
        AudioService.shared.seekTo(seconds: seconds)
        currentChapter?.isPlaying = AudioService.shared.isPlaying
    }
}

//MARK: Notification Handling
extension PlayerCellViewModel {
    @objc func eventsController(_ notification: Notification) {
        guard let event = notification.object else {return}
        switch event {
        case let progressEvent as AudioService.PlayProgressEvent:
            sliderValue = progressEvent.progress
            
        case let bufferEvent as AudioService.BufferChangeEvent:
            self.isBuffering = bufferEvent.isBuffering
        case _ as AudioService.ChapterFinishedEvent:
            self.currentChapter?.isPlaying = false
        case _ as AudioService.ChapterChangeEvent:
            loadChapter()
        default:
            print("===> Unknown")
        }
    }
    
    func subscribeAudioNotification() {
        unSubscribeAudioNotification()
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onAudioProgress,
                                       object: nil)
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onBufferingChange,
                                       object: nil)
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onChapterFinished,
                                       object: nil)
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onChapterChange,
                                       object: nil)
    }
    
    func unSubscribeAudioNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .onAudioProgress,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .onChapterFinished,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .onBufferingChange,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .onChapterChange,
                                                  object: nil)
    }
}
