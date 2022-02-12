//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 05/02/22.
//

import Foundation

public class RatingService {
    public static var shared = RatingService()
    private init() {}
    private let appLaunchCountKey:String = "app-launch-count-key"
    
    public func shouldRequest() -> Bool {
        let launchCount = incrementAppLaunchCount()
        
        switch launchCount {
        case 7:
            return true
        case _ where launchCount%100 == 0 :
            return true
        default:
            print("App run count is : \(launchCount)")
            break;
        }
        return false
    }
    
    private func incrementAppLaunchCount() -> Int {
        guard let appLaunchCount = UserDefaults.standard.value(forKey: self.appLaunchCountKey) as? Int else {
            UserDefaults.standard.set(1, forKey: self.appLaunchCountKey)
            UserDefaults.standard.synchronize()
            return 1
        }
        let newLanchCount = appLaunchCount + 1
        UserDefaults.standard.set(newLanchCount, forKey: self.appLaunchCountKey)
        UserDefaults.standard.synchronize()
        return newLanchCount
    }
}

