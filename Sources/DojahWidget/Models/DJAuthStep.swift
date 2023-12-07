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
