//
//  DJGovernmentID.swift
//
//
//  Created by Isaac Iniongun on 12/12/2023.
//

import Foundation

struct DJGovernmentID: Codable {
    let name, abbr: String?
    let subtext: String?
    let subtext2: String?
    let placeholder, idEnum: String?
    let spanid: String?
    let inputType, inputMode: DJInputMode?
    let minLength, maxLength, id, value: String?
    let idName: String?

    enum CodingKeys: String, CodingKey {
        case name, abbr, subtext, subtext2, placeholder
        case idEnum = "enum"
        case spanid, inputType, inputMode, minLength, maxLength, id, value, idName
    }
    
    var verificationModeParam: String? {
        guard let name else { return nil }
        if name.insensitiveContains("otp") {
            return "OTP"
        } else if name.insensitiveContains("selfie") {
            return "LIVENESS"
        } else {
            return nil
        }
    }
    
    var idTypeParam: String {
        idEnum ?? value ?? name ?? ""
    }
}

extension [DJGovernmentID] {
    var names: [String] { compactMap { $0.name } }
}
