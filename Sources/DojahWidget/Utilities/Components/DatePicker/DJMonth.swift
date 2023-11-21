//
//  DJMonth.swift
//
//
//  Created by Isaac Iniongun on 21/11/2023.
//

import Foundation

enum DJMonth: Int, CaseIterable {
    case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
    
    var name: String {
        switch self {
        case .jan:
            return "January"
        case .feb:
            return "February"
        case .mar:
            return "March"
        case .apr:
            return "April"
        case .may:
            return "May"
        case .jun:
            return "June"
        case .jul:
            return "July"
        case .aug:
            return "August"
        case .sep:
            return "September"
        case .oct:
            return "October"
        case .nov:
            return "November"
        case .dec:
            return "December"
        }
    }
}

extension [DJMonth] {
    var names: [String] {
        map { $0.name }
    }
}
