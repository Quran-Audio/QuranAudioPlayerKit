//
//  DownloadCellViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 24/01/22.
//

import Foundation
import CoreGraphics

class DownloadQueueViewModel:ObservableObject {
    @Published var progress:CGFloat = 0
    @Published var isDownloading:Bool = false
    @Published var downloadQueue:[ChapterModel] = []
    var progressInPi:CGFloat {progress * 360}
    var chapterName:String {DownloadService.shared.currentChapter?.name ?? ""}
    var chapterTrans:String {DownloadService.shared.currentChapter?.nameTrans ?? ""}
    var chapterSize:String {DownloadService.shared.currentChapter?.size ?? ""}
    
    private var baseUrl:String? = AudioService.shared.loadBaseUrl()
    
    init() {
        subscribeDownloadNotification()
        downloadQueue = DownloadService.shared.downloadList
    }
    
    var isConnectedToNetwork:Bool {ReachabilityService.isConnectedToNetwork()}
    
    var connectionAlertMessage:String? {
        let downloadWith = DataService.shared.getDownloadWith()
        if !ReachabilityService.isConnectedToNetwork() {
            if downloadWith == .cellularAndWifi {
                return "Change the Download Setting to 'Cellular And Wifi'".localize
            }
            return "Please check the Innternet connection".localize
        }
        return nil
    }

    func startDownload() {
        downloadQueue = DownloadService.shared.downloadList
        DownloadService.shared.processDownloadQueue()
        isDownloading.toggle()
    }
    
    func cancelDownload() {
        downloadQueue = DownloadService.shared.downloadList
        DownloadService.shared.cancelCurrentDownload()
        isDownloading = DownloadService.shared.isDownloadingInProgress
    }
    
    func addToDownloadQueueList(chapter:ChapterModel) {
        DownloadService.shared.addToDownloadQueue(chapter: chapter)
        downloadQueue = DownloadService.shared.downloadList
    }
    
    
    func removeFromDownloadQueueList(chapter:ChapterModel) {
        DownloadService.shared.removeFromDownloadQueue(chapter: chapter)
        downloadQueue = DownloadService.shared.downloadList
    }
    
    
    private func addToDownloadedList(index:Int) {
        DataService.shared.setDownloads(index: index)
    }
    
}

//MARK: Notification Handling
extension DownloadQueueViewModel {
    @objc func eventsController(_ notification: Notification) {
        guard let event = notification.object else {return}
        switch event {
        case let progressEvent as DownloadService.DownloadProgressEvent:
            if progressEvent.type == "download-progress" {
                progress = progressEvent.progress
                //isDownloading = DownloadService.shared.isDownloadingInProgress
                print("Progress \(progress)")
            }
        case let finishedEvent as DownloadService.DownloadFinishedEvent:
            downloadQueue = DownloadService.shared.downloadList
            addToDownloadedList(index: finishedEvent.chapterIndex)
            isDownloading = DownloadService.shared.isDownloadingInProgress
            print("Dowwnload Finished")
        case _ as DownloadService.DownloadStoppedEvent:
            downloadQueue = DownloadService.shared.downloadList
            isDownloading = DownloadService.shared.isDownloadingInProgress
            print("Dowwnload Stopped")
        default:
            print("===> Unknown")
        }
    }
    
    func subscribeDownloadNotification() {
        unSubscribeDownloadNotification()
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onDownloadFinished,
                                       object: nil)
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onDownloadStopped,
                                       object: nil)
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onDownloadProgress,
                                       object: nil)
    }
    
    func unSubscribeDownloadNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .onDownloadFinished,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .onDownloadStopped,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .onDownloadProgress,
                                                  object: nil)
    }
}

