//
//  DJGovernmentIDConfig.swift
//
//
//  Created by Isaac Iniongun on 12/12/2023.
//

import Foundation

// MARK: - GovernmentIDConfig
struct DJGovernmentIDConfig: Codable {
    let bvn, nin, vnin, dl: DJGovernmentID?
    let passport, national, permit, custom: DJGovernmentID?
    let voter: DJGovernmentID?
    let mobile: DJGovernmentID?
    let ngDLI, ngPass, ngNat, ukRP: DJGovernmentID?
    let ngCustom, ngVcard, ngNINSlip: DJGovernmentID?
    let selfie, otp: DJGovernmentID?
    let ghDL, ghVoter, tzNIN, ugID: DJGovernmentID?
    let ugTelco, keDL, keID, keKRA: DJGovernmentID?
    let saDL, saID: DJGovernmentID?
    let cac: DJGovernmentID?
    let tin: DJGovernmentID?
    
    init(
        bvn: DJGovernmentID? = nil,
        nin: DJGovernmentID? = nil,
        vnin: DJGovernmentID? = nil,
        dl: DJGovernmentID? = nil,
        passport: DJGovernmentID? = nil,
        national: DJGovernmentID? = nil,
        permit: DJGovernmentID? = nil,
        custom: DJGovernmentID? = nil,
        voter: DJGovernmentID? = nil,
        mobile: DJGovernmentID? = nil,
        ngDLI: DJGovernmentID? = nil,
        ngPass: DJGovernmentID? = nil,
        ngNat: DJGovernmentID? = nil,
        ukRP: DJGovernmentID? = nil,
        ngCustom: DJGovernmentID? = nil,
        ngVcard: DJGovernmentID? = nil,
        ngNINSlip: DJGovernmentID? = nil,
        selfie: DJGovernmentID? = nil,
        otp: DJGovernmentID? = nil,
        ghDL: DJGovernmentID? = nil,
        ghVoter: DJGovernmentID? = nil,
        tzNIN: DJGovernmentID? = nil,
        ugID: DJGovernmentID? = nil,
        ugTelco: DJGovernmentID? = nil,
        keDL: DJGovernmentID? = nil,
        keID: DJGovernmentID? = nil,
        keKRA: DJGovernmentID? = nil,
        saDL: DJGovernmentID? = nil,
        saID: DJGovernmentID? = nil,
        cac: DJGovernmentID? = nil,
        tin: DJGovernmentID? = nil
    ) {
        self.bvn = bvn
        self.nin = nin
        self.vnin = vnin
        self.dl = dl
        self.passport = passport
        self.national = national
        self.permit = permit
        self.custom = custom
        self.voter = voter
        self.mobile = mobile
        self.ngDLI = ngDLI
        self.ngPass = ngPass
        self.ngNat = ngNat
        self.ukRP = ukRP
        self.ngCustom = ngCustom
        self.ngVcard = ngVcard
        self.ngNINSlip = ngNINSlip
        self.selfie = selfie
        self.otp = otp
        self.ghDL = ghDL
        self.ghVoter = ghVoter
        self.tzNIN = tzNIN
        self.ugID = ugID
        self.ugTelco = ugTelco
        self.keDL = keDL
        self.keID = keID
        self.keKRA = keKRA
        self.saDL = saDL
        self.saID = saID
        self.cac = cac
        self.tin = tin
    }

    enum CodingKeys: String, CodingKey {
        case bvn, nin, vnin, dl, passport, national, permit, custom, voter, mobile
        case ngDLI = "NG-DLI"
        case ngPass = "NG-PASS"
        case ngNat = "NG-NAT"
        case ukRP = "UK-RP"
        case ngCustom = "NG-CUSTOM"
        case ngVcard = "NG-VCARD"
        case ngNINSlip = "NG-NIN-SLIP"
        case selfie, otp
        case ghDL = "gh-dl"
        case ghVoter = "gh-voter"
        case tzNIN = "tz-nin"
        case ugID = "ug-id"
        case ugTelco = "ug-telco"
        case keDL = "ke-dl"
        case keID = "ke-id"
        case keKRA = "ke-kra"
        case saDL = "sa-dl"
        case saID = "sa-id"
        case cac, tin
    }
}

// MARK: - Bvn
struct DJGovernmentID: Codable {
    let name, abbr: String?
    let subtext: String?
    let subtext2: String?
    let placeholder, configEnum: String?
    let spanid: String?
    let inputType, inputMode: DJInputMode?
    let minLength, maxLength, id, value: String?
    let idName: String?

    enum CodingKeys: String, CodingKey {
        case name, abbr, subtext, subtext2, placeholder
        case configEnum = "enum"
        case spanid, inputType, inputMode, minLength, maxLength, id, value, idName
    }
}

enum DJInputMode: String, Codable {
    case numeric = "numeric"
    case text = "text"
    case number = "number"
}
