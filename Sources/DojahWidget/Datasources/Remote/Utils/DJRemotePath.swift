//
//  DJRemotePath.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

enum DJRemotePath {
    case preAuth
    case auth
    case ipCheck
    case saveIP
    case events
    
    var path: String {
        switch self {
        case .preAuth:
            return "widget/pre-auth"
        case .auth:
            return "widget/auth"
        case .ipCheck:
            return "api/v1/ip"
        case .saveIP:
            return "widget/kyc/checks"
        case .events:
            return "widget/kyc/events"
        }
    }
    
    var absolutePath: String {
        "https://api-dev.dojah.services/\(path)"
    }
}
