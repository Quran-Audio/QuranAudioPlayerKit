//
//  FullPlayerViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 11/01/22.
//

import Foundation
import CoreGraphics

class FullPlayerViewModel:ObservableObject {
    //MARK: published
    @Published var currentChapter:ChapterModel?
    @Published var isBuffering:Bool = false
    @Published var sliderValue:CGFloat = 0
    @Published var currentTimeText:String = "0:00"

    private var baseUrl:String?
    
    //MARK: Stored Properties
    var isPlaying:Bool {AudioService.shared.isPlaying}
    var chapterName:String {currentChapter?.name ?? ""}
    var chapterNameTrans:String {currentChapter?.nameTrans ?? ""}
    var sliderCurrentValue:CGFloat {AudioService.shared.currentTimeInSecs}
    var sliderMaxValue:CGFloat {CGFloat(currentChapter?.durationInSecs ?? 0)}
        var durationText:String {
        AudioService.shared.durationText(secs: currentChapter?.durationInSecs ?? 0)
    }
    
    init() {
        subscribeAudioNotification()
        baseUrl = AudioService.shared.loadBaseUrl()
        isBuffering = AudioService.shared.isBuffering
        loadChapter()
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
    
    func onNext() {
        AudioService.shared.onNext()
    }
    
    func onPrevoius() {
        AudioService.shared.onPrevoius()
    }
    
    func loadChapter() {
        guard let currentChapter = AudioService.shared.loadChapter() else {return}
        self.currentChapter = currentChapter
    }
    
    func goBackTenSecs() {
        let currentSecs = AudioService.shared.currentTimeInSecs
        seekTo(seconds: currentSecs - 10)
    }
    
    func goForwardTenSecs() {
        let currentSecs = AudioService.shared.currentTimeInSecs
        seekTo(seconds: currentSecs + 10)
    }
}

//MARK: Notification Handling
extension FullPlayerViewModel {
    @objc func eventsController(_ notification: Notification) {
        guard let event = notification.object else {return}
        switch event {
        case _ as AudioService.PlayProgressEvent:
            sliderValue = AudioService.shared.currentTimeInSecs
            currentTimeText = AudioService.shared.currentTimeText
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
