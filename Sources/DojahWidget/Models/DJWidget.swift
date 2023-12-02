//
//  DJWidget.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

struct DJWidget: Codable {
    let published: Bool?
    let pages: [DJPage]?
    let countries: [String]?
    let env: String?
    let company: DJCompany?
    
    enum CodingKeys: String, CodingKey {
        case published, pages
        case countries = "country"
        case env, company
    }
}
