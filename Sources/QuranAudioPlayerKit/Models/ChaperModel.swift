//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 06/02/22.
//

import Foundation

public struct DataModel:Codable {
    public let baseUrl: String
    public let shareText: String
    public let mail: Mail
    public let chapters:[ChapterModel]
    
}

public struct Mail:Codable {
    public let subject: String
    public let to: [String]
}

public struct ChapterModel:Codable,Equatable,Identifiable {
    public var id: Int {index}
    public let index: Int
    public let name: String
    public let nameTrans: String
    public let fileName: String
    public let size: String
    public let durationInSecs: Int
    public var isPlaying:Bool? = false //Not loaded from file
    
    public static func ==(lhs: ChapterModel, rhs: ChapterModel) -> Bool {
        return lhs.index == rhs.index && lhs.fileName == lhs.fileName
    }
}

