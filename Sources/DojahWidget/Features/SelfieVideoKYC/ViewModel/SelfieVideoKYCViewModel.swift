//
//  SelfieVideoKYCViewModel.swift
//
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import Foundation

final class SelfieVideoKYCViewModel: BaseViewModel {
    weak var viewProtocol: SelfieVideoKYCViewProtocol?
    private let remoteDatasource: LivenessRemoteDatasourceProtocol
    let verificationMethod: GovtIDVerificationMethod
    
    init(
        remoteDatasource: LivenessRemoteDatasourceProtocol = LivenessRemoteDatasource(),
        verificationMethod: GovtIDVerificationMethod = .selfie
    ) {
        self.remoteDatasource = remoteDatasource
        self.verificationMethod = verificationMethod
        super.init()
    }
}
