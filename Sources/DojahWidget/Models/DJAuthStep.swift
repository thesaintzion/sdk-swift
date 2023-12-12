//
//  DJAuthRequestStep.swift
//
//
//  Created by Isaac Iniongun on 06/12/2023.
//

import Foundation

struct DJAuthStep: Codable {
    let name: DJPageName
    let id: Int
    let config: DJPageConfig
}

extension DJAuthStep {
    static let index = DJAuthStep(name: .index, id: 0, config: .init())
}
