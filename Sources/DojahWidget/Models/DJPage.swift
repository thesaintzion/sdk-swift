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
    let glassesCheck: Bool?
    let brightnessThreshold: Int?
    let ghDL, ghVoter: Bool?
    let keDL, keID, keKRA: Bool?
    let tzNIN: Bool?
    let ugID, ugTelco: Bool?
    let saID, saDL: Bool?
    let configDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case bvn, dl, vnin, nin
        case otp, selfie, cac, verification
        case passport, voter, national
        case type, version, instruction
        case glassesCheck, brightnessThreshold
        case ghDL = "gh-dl"
        case ghVoter = "gh-voter"
        case keDL = "ke-dl"
        case keID = "ke-id"
        case keKRA = "ke-kra"
        case tzNIN = "tz-nin"
        case ugID = "ug-id"
        case ugTelco = "ug-telco"
        case saID = "sa-id"
        case saDL = "sa-dl"
        case configDefault = "default"
    }
    
    init(
        bvn: Bool? = nil,
        dl: Bool? = nil,
        vnin: Bool? = nil,
        nin: Bool? = nil,
        otp: Bool? = nil,
        selfie: Bool? = nil,
        cac: Bool? = nil,
        verification: Bool? = nil,
        passport: Bool? = nil,
        voter: Bool? = nil,
        national: Bool? = nil,
        type: String? = nil,
        version: Int? = nil,
        instruction: String? = nil,
        glassesCheck: Bool? = nil,
        brightnessThreshold: Int? = nil,
        ghDL: Bool? = nil,
        ghVoter: Bool? = nil,
        keDL: Bool? = nil,
        keID: Bool? = nil,
        keKRA: Bool? = nil,
        tzNIN: Bool? = nil,
        ugID: Bool? = nil,
        ugTelco: Bool? = nil,
        saID: Bool? = nil,
        saDL: Bool? = nil,
        configDefault: String? = nil
    ) {
        self.bvn = bvn
        self.dl = dl
        self.vnin = vnin
        self.nin = nin
        self.otp = otp
        self.selfie = selfie
        self.cac = cac
        self.verification = verification
        self.passport = passport
        self.voter = voter
        self.national = national
        self.type = type
        self.version = version
        self.instruction = instruction
        self.glassesCheck = glassesCheck
        self.brightnessThreshold = brightnessThreshold
        self.ghDL = ghDL
        self.ghVoter = ghVoter
        self.keDL = keDL
        self.keID = keID
        self.keKRA = keKRA
        self.tzNIN = tzNIN
        self.ugID = ugID
        self.ugTelco = ugTelco
        self.saID = saID
        self.saDL = saDL
        self.configDefault = configDefault
    }
}
