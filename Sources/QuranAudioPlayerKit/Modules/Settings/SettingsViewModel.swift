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
}
