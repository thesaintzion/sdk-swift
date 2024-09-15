//
//  DJAuthResponse.swift
//
//
//  Created by Isaac Iniongun on 06/12/2023.
//

import Foundation

struct DJAuthResponse: Codable {
    let companyName: String?
    let initData: DJInitData?
    let appConfig: DJAppConfig?
    let sessionID, environment: String?
    let whiteLabel: Bool?
    let ucode: String?

    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case initData = "init_data"
        case appConfig = "app"
        case sessionID = "session_id"
        case environment
        case whiteLabel = "white_label"
        case ucode
    }
}
