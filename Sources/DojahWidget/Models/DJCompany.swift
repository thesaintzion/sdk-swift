//
//  DJCompany.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

struct DJCompany: Codable {
    let prodPublicKey: String?

    enum CodingKeys: String, CodingKey {
        case prodPublicKey = "prod_public_key"
    }
}
