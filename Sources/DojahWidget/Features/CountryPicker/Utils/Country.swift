//
//  Country.swift
//
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

enum Country: CaseIterable {
    case nigeria, ghana, kenya
    
    var name: String {
        switch self {
        case .nigeria:
            return "Nigeria"
        case .ghana:
            return "Ghana"
        case .kenya:
            return "Kenya"
        }
    }
    
    var flag: UIImage {
        switch self {
        case .nigeria:
            return .res(.ngFlag)
        case .ghana:
            return .res(.ghanaFlag)
        case .kenya:
            return .res(.kenyaFlag)
        }
    }
}
