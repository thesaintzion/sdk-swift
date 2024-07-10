//
//  DJAppConfig.swift
//  
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

struct DJAppConfig: Codable {
    let name: String?
    let logo: String?
    let colorCode, id: String?

    enum CodingKeys: String, CodingKey {
        case name, logo
        case colorCode = "color_code"
        case id
    }
}
