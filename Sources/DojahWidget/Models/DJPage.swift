//
//  DJPage.swift
//  
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

struct DJPage: Codable {
    let page: String?
    let config: DJPageConfig?
}

struct DJPageConfig: Codable {
    let bvn, dl, vnin, nin: Bool?
    let otp, selfie, cac, verification: Bool?
    let passport, voter, national: Bool?
    let type: String?
    let version: Int?
    let instruction: String?
}
