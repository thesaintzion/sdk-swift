//
//  BusinessDataType.swift
//
//
//  Created by Isaac Iniongun on 13/02/2024.
//

import Foundation

enum BusinessDataType: String {
    case cac = "RC-NUMBER", tin = "TIN"
    
    var remotePath: DJRemotePath {
        switch self {
        case .cac:
            return .cac
        case .tin:
            return .tin
        }
    }
    
    var verificationRequestParam: String {
        switch self {
        case .cac:
            return "rc_number"
        case .tin:
            return "tin"
        }
    }
}
