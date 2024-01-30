//
//  ImageCheckResponse.swift
//
//
//  Created by Isaac Iniongun on 30/01/2024.
//

import Foundation

struct ImageCheckResponse: Codable {
    let match: Bool?
    let reason: String?
    let continueVerification: Bool?

    enum CodingKeys: String, CodingKey {
        case match, reason
        case continueVerification = "continue_verification"
    }
}
