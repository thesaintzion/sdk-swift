//
//  EmailCollectedEventResponse.swift
//  
//
//  Created by Isaac Iniongun on 02/05/2024.
//

import Foundation

struct EmailCollectedEventResponse: Codable {
    let success, continueVerification, duplicateReference: Bool?
    let data: DJInitDataConfig?
    let msg, message: String?
    
    enum CodingKeys: String, CodingKey {
        case success, data, msg, message
        case continueVerification = "continue_verification"
        case duplicateReference = "duplicate_reference"
    }
}
