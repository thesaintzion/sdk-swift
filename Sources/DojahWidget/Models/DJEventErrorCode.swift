//
//  DJEventErrorCode.swift
//  
//
//  Created by Isaac Iniongun on 15/03/2024.
//

import Foundation

enum DJEventErrorCode: String {
    case invalidOTP = "04"
    case imageCheckFailedAfterMaxRetries = "10"
    case thirdParty = "03"
    case unknown = "01"
    case invalidIDNotFound = "02"
}
