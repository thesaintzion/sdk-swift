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
    var services: [String]
    
    init(name: DJEventName, value: String, services: [String] = []) {
        self.name = name
        self.value = value
        self.services = services
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "event_type"
        case value = "event_value"
        case services
    }
    
    var hasServices: Bool {
        [.stepFailed, .stepCompleted].contains(name)
    }
}

extension DJEventRequest {
    static func event(name: DJEventName, pageName: DJPageName, services: [String] = []) -> DJEventRequest {
        .init(
            name: name,
            value: pageName.rawValue,
            services: services
        )
    }
    
    static func stepFailed(errorCode: DJEventErrorCode, services: [String] = []) -> DJEventRequest {
        .init(
            name: .stepFailed,
            value: errorCode.rawValue,
            services: services
        )
    }
}
