//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 18/02/22.
//

import Foundation

extension String {
    var localize: String {
        return LocalizationService.shared.translate(key: self)
    }
}
