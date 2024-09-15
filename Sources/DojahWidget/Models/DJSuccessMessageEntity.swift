//
//  DJSuccessMessageEntity.swift
//
//
//  Created by Isaac Iniongun on 08/12/2023.
//

import Foundation

typealias SuccessEntityResponse = EntityResponse<DJSuccessMessageEntity>

struct DJSuccessMessageEntity: Codable {
    let success: Bool?
    let msg: String?
}
