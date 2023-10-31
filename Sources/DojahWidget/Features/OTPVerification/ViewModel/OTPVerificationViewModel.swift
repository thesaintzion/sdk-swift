//
//  OTPVerificationViewModel.swift
//
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import Foundation

final class OTPVerificationViewModel {
    private let verificationMethod: GovtIDVerificationMethod
    var isPhoneNumberVerification: Bool {
        verificationMethod == .phoneNumberOTP
    }
    var verificationInfo = ""
    
    init(verificationMethod: GovtIDVerificationMethod) {
        self.verificationMethod = verificationMethod
    }
}
