//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 05/02/22.
//

import Foundation
import StoreKit

public class RatingService {
    public static var shared = RatingService()
    private init() {}
    
    private let appLaunchCountKey:String = "app-launch-count-key"
    public func checkAndAskForReview() {
        let incrementedAppLaunchCount = incrementAppLaunchCount()
        
        switch incrementedAppLaunchCount {
        case 7:
            requestReview()
        case _ where incrementedAppLaunchCount%100 == 0 :
            requestReview()
        default:
            print("App run count is : \(incrementedAppLaunchCount)")
            break;
        }
        
    }
    
    private func requestReview() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
    
    private func incrementAppLaunchCount() -> Int {
        guard let appLaunchCount = UserDefaults.standard.value(forKey: self.appLaunchCountKey) as? Int else {
            UserDefaults.standard.set(1, forKey: self.appLaunchCountKey)
            UserDefaults.standard.synchronize()
            return 1
        }
        print(appLaunchCount)
        UserDefaults.standard.set(appLaunchCount+1, forKey: self.appLaunchCountKey)
        UserDefaults.standard.synchronize()
        return appLaunchCount
    }
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            requestReview(in: scene)
        }
    }
}


