//
//  GovtIDVerificationMethod.swift
//
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

enum GovtIDVerificationMethod: Int, CaseIterable, SelectableItem {
    case govtID, selfie, phoneNumberOTP, emailOTP, videoKYC
    
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
        case .govtID:
            return "Govt. ID"
        }
    }
    
    var kycText: String {
        switch self {
        case .selfie:
            return "Capture"
        case .phoneNumberOTP, .emailOTP, .govtID:
            return ""
        case .videoKYC:
            return "Record"
        }
    }
    
    var iconConfig: IconConfig { .init() }
}

extension [GovtIDVerificationMethod] {
    var titles: [String] {
        map { $0.title }
    }
}
