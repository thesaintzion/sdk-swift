//
//  Country.swift
//
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

enum Country: Int, CaseIterable, SelectableItem {
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
            return .res("ngFlag")
        case .ghana:
            return .res("ghanaFlag")
        case .kenya:
            return .res("kenyaFlag")
        }
    }
    
    var title: String { name }
    
    var iconConfig: IconConfig {
        .init(
            icon: flag,
            size: .init(width: 19, height: 14),
            contentMode: .scaleAspectFill
        )
    }
    
    var phoneCode: String {
        switch self {
        case .nigeria:
            return "+234"
        case .ghana:
            return "+233"
        case .kenya:
            return "+254"
        }
    }
    
    var emoticon: String {
        switch self {
        case .nigeria:
            return "🇳🇬"
        case .ghana:
            return "🇬🇭"
        case .kenya:
            return "🇺🇬"
        }
    }
}

extension [Country] {
    var names: [String] {
        map { "\($0.emoticon)  \($0.name)" }
    }
}
