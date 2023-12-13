//
//  DJRemotePath.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

enum DJRemotePath {
    case none
    case preAuth
    case auth
    case ipCheck
    case saveIP
    case events
    case ninLookup
    case bvnLookup
    case vninLookup
    case basicPhoneNumberLookup
    case advancedPhoneNumberLookup
    case driversLicenseLookup
    
    var path: String {
        switch self {
        case .none:
            return ""
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
        case .ninLookup:
            return "widget/kyc/nin"
        case .bvnLookup:
            return "widget/kyc/bvn"
        case .vninLookup:
            return "widget/kyc/vnin"
        case .basicPhoneNumberLookup:
            return "widget/kyc/mobile/basic"
        case .advancedPhoneNumberLookup:
            return "widget/kyc/mobile/advance"
        case .driversLicenseLookup:
            return "widget/kyc/dl"
        }
    }
    
    var absolutePath: String {
        "https://api-dev.dojah.services/\(path)"
    }
}
