//
//  DJGovernmentDataViewModel.swift
//
//
//  Created by Isaac Iniongun on 12/12/2023.
//

import Foundation

final class DJGovernmentDataViewModel: BaseViewModel {
    weak var viewProtocol: GovernmentDataViewProtocol?
    private let remoteDatasource: GovernmentDataRemoteDatasourceProtocol
    var governmentIDs = [DJGovernmentID]()
    var governmentIDVerificationMethods = [DJGovernmentID]()
    var selectedGovernmentID: DJGovernmentID?
    var selectedGovernmentIDVerificationMethod: DJGovernmentID?
    
    init(remoteDatasource: GovernmentDataRemoteDatasourceProtocol = GovernmentDataRemoteDatasource()) {
        self.remoteDatasource = remoteDatasource
        super.init()
    }
    
    func getGovernmentIDConfiguration() {
        guard let govtDataConfig = preference.DJGovernmentIDConfig else { return }
        let govtDataAuthStep = preference.DJAuthStep
        
        // Identification Methods
        if govtDataAuthStep.config.bvn == true, let bvnConfig = govtDataConfig.bvn {
            governmentIDs.append(bvnConfig)
        }
        
        if govtDataAuthStep.config.dl == true, let dlConfig = govtDataConfig.dl {
            governmentIDs.append(dlConfig)
        }
        
        if govtDataAuthStep.config.nin == true, let ninConfig = govtDataConfig.nin {
            governmentIDs.append(ninConfig)
        }
        
        if govtDataAuthStep.config.vnin == true, let vninConfig = govtDataConfig.vnin {
            governmentIDs.append(vninConfig)
        }
        
        //Verification Methods
        if govtDataAuthStep.config.selfie == true, let selfieConfig = govtDataConfig.selfie {
            governmentIDVerificationMethods.append(selfieConfig)
        }
        
        if govtDataAuthStep.config.otp == true, let otpConfig = govtDataConfig.otp {
            governmentIDVerificationMethods.append(otpConfig)
        }
        
    }
    
    func didChooseGovernmentData(at index: Int, type: GovernmentDataType) {
        switch type {
        case .id:
            selectedGovernmentID = governmentIDs[index]
            viewProtocol?.showGovtIDNumberTextField()
        case .verificationMethod:
            selectedGovernmentIDVerificationMethod = governmentIDs[index]
        }
    }
}
