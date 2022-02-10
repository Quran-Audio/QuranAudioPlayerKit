//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 06/02/22.
//

import UIKit

public class DownloadService: NSObject,URLSessionDownloadDelegate {
    public var currentChapter:ChapterModel? {downloadList.first}
    private var baseUrl:String = DataService.shared.baseUrl
    public var downloadList:[ChapterModel] {
        DataService.shared.getChaptersInDownloadQueue()
    }
    public static var shared = DownloadService()
    private override init() {}
    private var task:URLSessionDownloadTask?
    private var session:URLSession?
    public var isDownloadingInProgress:Bool = false
    
    public func startDownload() {
        if task?.state != .running {
            guard let url = URL(string: "https://archive.org/download/malayalam-meal/000_Al_Fattiha.mp3") else {return}
            let session = URLSession(configuration: .default,
                                     delegate: self,
                                     delegateQueue: .main)
            task = session.downloadTask(with: url)
            task?.resume()
        }
    }
    
    
    //FIXME: To Be deleted
    private func startFileDownload(chapter:ChapterModel) {
        guard let url = URL(string: "\(baseUrl)\(chapter.fileName)") else {
            return
        }
        let conf = URLSessionConfiguration.default
        conf.allowsCellularAccess = DataService.shared.getDownloadWith() == .cellularAndWifi ? true : false
        conf.waitsForConnectivity = true
        session?.invalidateAndCancel()
        session = URLSession(configuration: conf,
                                 delegate: self,
                                 delegateQueue: .main)
        task = session?.downloadTask(with: url)
        task?.resume()
        isDownloadingInProgress = true
    }
    
    
    // MARK: protocol stub for download completion tracking
    public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        let chapter = downloadList.first
        moveFrom(source: location,chapter:chapter)
        removeFromDownloadQueue(chapter: chapter)
        isDownloadingInProgress = false
        publishDownnloadFinished(chapterIndex: chapter?.index ?? 0)
        processDownloadQueue()
    }
    
    // MARK: protocol stubs for tracking download progress
    public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        publishDownloadProgress(progress: progress)
    }

    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        publishDownloadStopped()
        processDownloadQueue()
    }
    
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("taskIsWaitingForConnectivity fi\(task.state)")
    }
    
    private func moveFrom(source:URL,chapter:ChapterModel?) {
        guard let chapter = chapter else {return}

        do {
            let directory = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true)
            let destination: URL
            destination = directory
                .appendingPathComponent(chapter.fileName)
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager.default.moveItem(at: source, to: destination)
        }catch {
            print("File Copy error : \(error.localizedDescription)")
        }
    }
}

//MARK: Notification
extension DownloadService {
    public struct DownloadStoppedEvent:Equatable {
        public let type = "download-stopped"
    }
    
    public struct DownloadFinishedEvent:Equatable {
        public let type = "download-finished"
        public let chapterIndex:Int
    }
    
    public struct DownloadProgressEvent:Equatable {
        public let type = "download-progress"
        public var progress:CGFloat
        public var chapterName:String
    }
    
    
    
    private func publishDownnloadFinished(chapterIndex:Int) {
        NotificationCenter.default.post(name:.onDownloadFinished,
                                        object: DownloadFinishedEvent(chapterIndex:chapterIndex),
                                        userInfo: nil)
    }
    
    private func publishDownloadProgress(progress:CGFloat) {
        NotificationCenter.default.post(name:.onDownloadProgress,
                                        object: DownloadProgressEvent(progress: progress,
                                                                      chapterName: downloadList.first?.name ?? ""),
                                        userInfo: nil)
    }
    
    private func publishDownloadStopped () {
        NotificationCenter.default.post(name:.onDownloadStopped,
                                        object: DownloadStoppedEvent(),
                                        userInfo: nil)
    }
}

extension Notification.Name {
    public static var onDownloadFinished: Notification.Name {
        return .init(rawValue: "Download.Finished")
    }
    
    public static var onDownloadProgress: Notification.Name {
        return .init(rawValue: "Download.Progress")
    }
    
    public static var onDownloadStopped: Notification.Name {
        return .init(rawValue: "Download.Stopped")
    }
}


//MARK: Download Queue Management
extension DownloadService {
    func setBaseUrl(ulr:String) {
        self.baseUrl = ulr
    }
    
    public func addToDownloadQueue(chapter:ChapterModel) {
        DataService.shared.addToDownloadQueue(index: chapter.index)
    }
    
    public func removeFromDownloadQueue(chapter:ChapterModel?) {
        guard let chapter = chapter else {return}
        DataService.shared.removeFromDownloadQueue(index: chapter.index)
    }
    
    public func processDownloadQueue() {
        if isDownloadingInProgress {
            if task?.state == .running {
                task?.suspend()            }
            else if task?.state == .suspended {
                task?.resume()
            }
        }else {
            if let chapter = downloadList.first {
                startFileDownload(chapter: chapter)
                isDownloadingInProgress = true
            }
        }
    }
    
    public func cancelCurrentDownload() {
        isDownloadingInProgress = false
        removeFromDownloadQueue(chapter: downloadList.first)
        session?.invalidateAndCancel()
        task?.cancel()
        publishDownloadStopped()
        processDownloadQueue()
    }
}
