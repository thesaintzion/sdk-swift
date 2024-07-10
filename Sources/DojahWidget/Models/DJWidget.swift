//
//  DJWidget.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

struct DJWidget: Codable {
    let published: Bool?
    let reviewProcess: String?
    let pages: [DJPage]?
    let countries: [String]?
    let env: String?
    let company: DJCompany?
    let duplicateCheck, directFeedback: Bool?
    let rules: DJWidgetRules?
    
    enum CodingKeys: String, CodingKey {
        case published, pages
        case countries = "country"
        case env, company
        case reviewProcess = "review_process"
        case duplicateCheck = "duplicate_check"
        case directFeedback = "direct_feedback"
        case rules
    }
}

struct DJWidgetRules: Codable {}
