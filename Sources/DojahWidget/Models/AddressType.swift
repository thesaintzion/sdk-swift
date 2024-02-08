//
//  AddressType.swift
//
//
//  Created by Isaac Iniongun on 08/02/2024.
//

import Foundation

enum AddressType {
    case userSelected
    case userLocation
    
    var remotePath: DJRemotePath {
        switch self {
        case .userSelected:
            return .baseAddress
        case .userLocation:
            return .address
        }
    }
}
