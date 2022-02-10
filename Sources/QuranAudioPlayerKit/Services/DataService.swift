//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 06/02/22.
//

import Foundation

public class DataService {
    public static var shared = DataService()
    public var baseUrl:String = ""
    public var shareText:String = ""
    public var mailSubject:String = ""
    public var mailTo:[String] = []
    public var chapterList:[ChapterModel] = []
    private init() {loadData()}
    
    func loadData() {
        guard let path = Bundle.main.path(forResource: "Data", ofType: "json") else {
            print("Invalid file")
            return
        }
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let chapterMetaData = try decoder.decode(DataModel.self, from: data)
            baseUrl = chapterMetaData.baseUrl
            shareText = chapterMetaData.shareText
            chapterList = chapterMetaData.chapters
            mailSubject = chapterMetaData.mail.subject
            mailTo = chapterMetaData.mail.to
        } catch DecodingError.keyNotFound(let key, let context) {
            Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
        } catch let error as NSError {
            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
    }
    
    
    //MARK: Favourites
    public func getFavourites() -> [Int] {
        guard let favourites = UserDefaults.standard.object(forKey: "QMFavourites") as? [Int] else {
            return []
        }
        return favourites
    }
    
    public func setFavourite(index:Int) {
        var favourites = getFavourites()
        if !favourites.contains(index) {
            favourites.append(index)
            UserDefaults.standard.set(favourites, forKey: "QMFavourites")
        }
    }
    
    public func removeFavourite(chapterIndex:Int) {
        var favourites = getFavourites()
        if let index = favourites.firstIndex(of: chapterIndex) {
            favourites.remove(at: index)
        }
        UserDefaults.standard.set(favourites, forKey: "QMFavourites")
    }
    
    public func isFavourite(index:Int) -> Bool {
        let favourites = getFavourites()
        return favourites.contains(index) ? true : false
    }
    
    //MARK: Downnloaded
    public func getDownloads() -> [Int] {
        guard let downloads = UserDefaults.standard.object(forKey: "QMDownloads") as? [Int] else {
            return []
        }
        return downloads
    }
    
    public func setDownloads(index:Int) {
        var downloads = getDownloads()
        if !downloads.contains(index) {
            downloads.append(index)
            UserDefaults.standard.set(downloads, forKey: "QMDownloads")
        }
    }
    
    public func isDownloaded(index:Int) -> Bool {
        let downloads = getDownloads()
        return downloads.contains(index) ? true : false
    }
    
    public func deleteDownloaded(chapter:ChapterModel) {
        var downloads = getDownloads()
        if let index = downloads.firstIndex(of: chapter.index) {
            deleteFile(chapter: chapter)
            downloads.remove(at: index)
        }
        UserDefaults.standard.set(downloads, forKey: "QMDownloads")
    }
    
    
    private func deleteFile(chapter:ChapterModel) {
        do {
            let directory = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true)
            let localUrl = directory
                .appendingPathComponent(chapter.fileName)
            if FileManager.default.fileExists(atPath: localUrl.path) {
                try FileManager.default.removeItem(atPath: localUrl.path)
            }
        }catch {
            print("Error \(error)")
        }
    }
}

//MARK: Download with
extension DataService {
    public enum DownloadWith:Int {
        case wifi
        case cellularAndWifi
    }
    
    public func getDownloadWith() -> DownloadWith {
        let rawValue = UserDefaults.standard.integer(forKey:"QMDownloadWWith")
        return DownloadWith(rawValue:rawValue) ?? .wifi
    }
    
    public func set(downloadWith:DownloadWith) {
        UserDefaults.standard.set(downloadWith.rawValue, forKey: "QMDownloadWWith")
    }
}

//MARK: Download Queue
extension DataService {
    //MARK: Downnloaded
    public func getDownloadQueue() -> [Int] {
        guard let downloadQueue = UserDefaults.standard.object(forKey: "QMDownloadQueue") as? [Int] else {
            return []
        }
        return downloadQueue
    }
    
    public func getChaptersInDownloadQueue() -> [ChapterModel] {
        let downloadQueue = getDownloadQueue()
        return chapterList.filter({ chapter in
            downloadQueue.contains(chapter.index)
        })
    }
    
    public func addToDownloadQueue(index:Int) {
        var downloadQueue = getDownloadQueue()
        if !downloadQueue.contains(index) {
            downloadQueue.append(index)
            UserDefaults.standard.set(downloadQueue, forKey: "QMDownloadQueue")
        }
    }
    
    public func isInDownloadQueue(index:Int) -> Bool {
        let downloadQueue = getDownloadQueue()
        return downloadQueue.contains(index) ? true : false
    }
    
    public func removeFromDownloadQueue(index:Int) {
        var downloadQueue = getDownloadQueue()
        if let index = downloadQueue.firstIndex(of: index) {
            downloadQueue.remove(at: index)
        }
        UserDefaults.standard.set(downloadQueue, forKey: "QMDownloadQueue")
    }
}

