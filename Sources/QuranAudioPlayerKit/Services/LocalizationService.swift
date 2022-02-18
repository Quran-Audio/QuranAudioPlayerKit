//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 18/02/22.
//

import Foundation
class LocalizationService {
    static var shared = LocalizationService()
    private var localeDict:[String:String]? = [:]
    private init() {
        localeDict = loadLocalization()
    }
    
    private func loadLocalization() -> [String: String]? {
        guard let path = Bundle.main.path(forResource: "Localization", ofType: "json") else {
            print("Invalid file")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func translate(key:String) -> String {
        return self.localeDict?[key] ?? key
    }
}
