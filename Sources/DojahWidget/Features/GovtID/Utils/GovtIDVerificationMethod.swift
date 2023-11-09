//
//  GovtIDVerificationMethod.swift
//
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

enum GovtIDVerificationMethod: CaseIterable, SelectableItem {
    case selfie, phoneNumberOTP, emailOTP, videoKYC //, homeAddress
    
    var title: String {
        switch self {
        case .selfie:
            return "Selfie"
        case .phoneNumberOTP:
            return "Phone Number OTP"
        case .emailOTP:
            return "Email OTP"
        case .videoKYC:
            return "Video KYC"
//        case .homeAddress:
//            return "Home Address"
        }
    }
    
    var iconConfig: IconConfig { .init() }
}
