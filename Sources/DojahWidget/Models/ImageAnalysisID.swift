//
//  ImageAnalysisID.swift
//
//
//  Created by Isaac Iniongun on 02/02/2024.
//

import Foundation

struct ImageAnalysisID: Codable {
    let labelsDetected: Bool?
    let message: String?
    let details: ImageAnalysisIDDetails?

    enum CodingKeys: String, CodingKey {
        case labelsDetected = "labels_detected"
        case message, details
    }
}

struct ImageAnalysisIDDetails: Codable {
    let text, document, idCards, passport: Double?
    let drivingLicense: Double?

    enum CodingKeys: String, CodingKey {
        case text, document
        case idCards = "id_cards"
        case passport
        case drivingLicense = "driving_license"
    }
}
