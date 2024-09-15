//
//  GovtID.swift
//
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

enum GovtID: Int, CaseIterable, SelectableItem {
    case bvn, driversLicense, cac, otherDoc
    
    var title: String {
        switch self {
        case .bvn:
            return "BVN Verification"
        case .driversLicense:
            return "Driver’s License"
        case .cac:
            return "CAC"
        case .otherDoc:
            return "Other Doc"
        }
    }
    
    var numberTitle: String {
        switch self {
        case .bvn:
            return "BVN Number"
        case .driversLicense:
            return "Driver’s License Number"
        case .cac:
            return "CAC Number"
        case .otherDoc:
            return "Document Number"
        }
    }
    
    var iconConfig: IconConfig { .init() }
}

extension [GovtID] {
    var titles: [String] {
        map { $0.title }
    }
}
