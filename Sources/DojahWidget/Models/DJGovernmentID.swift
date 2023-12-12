//
//  DJGovernmentID.swift
//
//
//  Created by Isaac Iniongun on 12/12/2023.
//

import Foundation
import UIKit

struct DJGovernmentID: Codable {
    let name, abbr: String?
    let subtext: String?
    let subtext2: String?
    let placeholder, idType: String?
    let spanid: String?
    let inputType, inputMode: DJInputMode?
    let minLength, maxLength, id, value: String?
    let idName: String?

    enum CodingKeys: String, CodingKey {
        case name, abbr, subtext, subtext2, placeholder
        case idType = "enum"
        case spanid, inputType, inputMode, minLength, maxLength, id, value, idName
    }
}

extension [DJGovernmentID] {
    var names: [String] { compactMap { $0.name } }
}

enum DJGovernmentIDType: String, Codable {
    case bvn = "BVN"
    case nin = "NIN"
    case vnin = "VNIN"
    case dl = "DL"
    case mobile = "MOBILE"
    case dlID = "DL_ID"
    case passportID = "PASSPORT_ID"
    case nationalID = "NATIONAL_ID"
    case residencePermit = "RESIDENCE_PERMIT"
    case customID = "CUSTOM_ID"
    case ngVotersCard = "NG-VCARD"
    case ngNINSlip = "NG-NIN-SLIP"
    case ghDL = "GH-DL"
    case ghVotersCard = "GH-VOTER"
    case tzNIN = "TZ-NIN"
    case ugID = "UG-ID"
    case ugTELCO = "UG-TELCO"
    case keDL = "KE-DL"
    case keID = "KE-ID"
    case keKRA = "KE-KRA"
    case saDL = "SA-DL"
    case saID = "SA-ID"
    case cacRCNumber = "RC-NUMBER"
    case tin = "TIN"
}

enum DJInputMode: String, Codable {
    case numeric = "numeric"
    case text = "text"
    case number = "number"
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .numeric, .number:
            return .numberPad
        case .text:
            return .alphabet
        }
    }
}
