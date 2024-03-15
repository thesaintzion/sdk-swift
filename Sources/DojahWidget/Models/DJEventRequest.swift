//
//  DJEventRequest.swift
//
//
//  Created by Isaac Iniongun on 07/12/2023.
//

import Foundation

struct DJEventRequest: Codable {
    let name: DJEventName
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case name = "event_type"
        case value = "event_value"
    }
}

extension DJEventRequest {
    static func event(name: DJEventName, pageName: DJPageName) -> DJEventRequest {
        DJEventRequest(name: name, value: pageName.rawValue)
    }
    
    static func stepFailed(errorCode: DJEventErrorCode) -> DJEventRequest {
        DJEventRequest(name: .stepFailed, value: errorCode.rawValue)
    }
}
