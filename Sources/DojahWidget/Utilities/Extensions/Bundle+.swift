//
//  Bundle+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation
import UIKit

extension Bundle {
    func value<T>(for key: String) -> T? {
        object(forInfoDictionaryKey: key) as? T
    }
    
    var baseURL: String { value(for: "BASE_URL")! }
    
    var appBundleID: String { value(for: "BASE_URL")! }
    
}
