//
//  ImageVerificationResponse.swift
//
//
//  Created by Isaac Iniongun on 30/01/2024.
//

import Foundation

struct ImageVerificationResponse: Codable {
    let person: ImageVerificationValue?
    let id: Business?
    let overall: ImageVerificationValue?
    let business: Business?
    let device, ip, referenceID: String?

    enum CodingKeys: String, CodingKey {
        case person, id, overall, business, device, ip
        case referenceID = "reference_id"
    }
}

struct Business: Codable {}

struct ImageVerificationValue: Codable {
    let url: String?
    let confidenceValue: Double?

    enum CodingKeys: String, CodingKey {
        case url
        case confidenceValue = "confidence_value"
    }
}
