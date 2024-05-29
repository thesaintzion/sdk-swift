//
//  DJAuthRequestStep.swift
//
//
//  Created by Isaac Iniongun on 06/12/2023.
//

import Foundation

struct DJAuthStep: Codable, Equatable {
    let name: DJPageName?
    let id: Int?
    let config: DJPageConfig?
    let sessionID: String?
    let status: DJAuthStepStatus?
    
    init(
        name: DJPageName? = nil,
        id: Int? = nil,
        config: DJPageConfig? = nil,
        sessionID: String? = nil,
        status: DJAuthStepStatus? = nil
    ) {
        self.name = name
        self.id = id
        self.config = config
        self.sessionID = sessionID
        self.status = status
    }
    
    enum CodingKeys: String, CodingKey {
        case name, id, config, status
        case sessionID = "session_id"
    }
    
    static func == (lhs: DJAuthStep, rhs: DJAuthStep) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}

enum DJAuthStepStatus: String, Codable {
    case done, notdone, pending, failed
}

extension DJAuthStep {
    static let index = DJAuthStep(name: .index, id: 0, config: .init())
}

extension [DJAuthStep] {
    func by(statuses: [DJAuthStepStatus?]) -> [DJAuthStep] {
        filter { statuses.contains($0.status) }
    }
}
