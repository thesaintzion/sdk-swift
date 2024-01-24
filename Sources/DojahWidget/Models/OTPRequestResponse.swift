//
//  OTPRequestResponse.swift
//
//
//  Created by Isaac Iniongun on 13/12/2023.
//

import Foundation

struct OTPRequestResponse: Codable {
    let referenceID, destination, statusID, status: String?

    enum CodingKeys: String, CodingKey {
        case referenceID = "reference_id"
        case destination
        case statusID = "status_id"
        case status
    }
}
