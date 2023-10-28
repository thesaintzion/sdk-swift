//
//  GovtID.swift
//
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

enum GovtID: CaseIterable, SelectableItem {
    case bvn, driversLicense
    
    var title: String {
        switch self {
        case .bvn:
            return "BVN Verification"
        case .driversLicense:
            return "Driver’s License"
        }
    }
    
    var numberTitle: String {
        switch self {
        case .bvn:
            return "BVN Number"
        case .driversLicense:
            return "Driver’s License Number"
        }
    }
    
    var iconConfig: IconConfig { .init() }
}
