//
//  SettingsViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 29/01/22.
//

import Foundation
class SettingsViewModel:ObservableObject {
    var shareText: String {
        return DataService.shared.shareText
    }
    
    @Published var downloadWith:DataService.DownloadWith = .wifi
    @Published var downloadWithPlay:Bool = false
    
    init() {
        downloadWith = DataService.shared.getDownloadWith()
        downloadWithPlay = DataService.shared.isDownloadWhilePlay()
    }
    
    func setDownloadWithWifi() {
        DataService.shared.set(downloadWith: .wifi)
        loadSettings()
    }
    
    func setDownloadWithCellularAndWifi() {
        DataService.shared.set(downloadWith: .cellularAndWifi)
        loadSettings()
    }
    
    private func loadSettings() {
        downloadWith = DataService.shared.getDownloadWith()
    }
    
    func isDownloadWhilePlay() -> Bool {
        DataService.shared.isDownloadWhilePlay()
    }
    
    func setDownloadWhilePlay() {
        DataService.shared.setDownloadWhilePlaying()
        downloadWithPlay = DataService.shared.isDownloadWhilePlay()
    }
}
