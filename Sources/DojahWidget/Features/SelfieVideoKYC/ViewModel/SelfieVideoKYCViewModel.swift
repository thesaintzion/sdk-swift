//
//  SelfieVideoKYCViewModel.swift
//
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import Foundation

final class SelfieVideoKYCViewModel {
    private let verificationMethod: GovtIDVerificationMethod
    
    init(verificationMethod: GovtIDVerificationMethod) {
        self.verificationMethod = verificationMethod
    }
}
