//
//  DJInitData.swift
//
//
//  Created by Isaac Iniongun on 07/12/2023.
//

import Foundation

struct DJInitData: Codable {
    let success: Bool?
    let msg: String?
    let data: DJInitDataConfig?
}

struct DJInitDataConfig: Codable {
    let verificationID: Int?
    let steps: [DJAuthStep]?
    let stepNumber: Int?
    let referenceID, sessionID, verificationTypeSelected: String?

    enum CodingKeys: String, CodingKey {
        case verificationID = "verification_id"
        case steps
        case stepNumber = "step_number"
        case referenceID = "reference_id"
        case sessionID = "session_id"
        case verificationTypeSelected = "verification_type_selected"
    }
}
