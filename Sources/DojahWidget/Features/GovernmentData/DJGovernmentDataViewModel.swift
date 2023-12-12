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
        let authStep = preference.DJAuthStep
        
        // Identification Methods
        if authStep.config.bvn == true, let bvnConfig = govtDataConfig.bvn {
            governmentIDs.append(bvnConfig)
        }
        
        if authStep.config.dl == true, let dlConfig = govtDataConfig.dl {
            governmentIDs.append(dlConfig)
        }
        
        if authStep.config.nin == true, let ninConfig = govtDataConfig.nin {
            governmentIDs.append(ninConfig)
        }
        
        if authStep.config.vnin == true, let vninConfig = govtDataConfig.vnin {
            governmentIDs.append(vninConfig)
        }
        
        if authStep.config.passport == true, let passport = govtDataConfig.passport {
            governmentIDs.append(passport)
        }
        
        if authStep.config.national == true, let national = govtDataConfig.national {
            governmentIDs.append(national)
        }
        
        if authStep.config.voter == true, let voter = govtDataConfig.voter {
            governmentIDs.append(voter)
        }
        
        if authStep.config.ghDL == true, let ghDL = govtDataConfig.ghDL {
            governmentIDs.append(ghDL)
        }
        
        if authStep.config.ghVoter == true, let ghVoter = govtDataConfig.ghVoter {
            governmentIDs.append(ghVoter)
        }
        
        if authStep.config.tzNIN == true, let tzNIN = govtDataConfig.tzNIN {
            governmentIDs.append(tzNIN)
        }
        
        if authStep.config.ugID == true, let ugID = govtDataConfig.ugID {
            governmentIDs.append(ugID)
        }
        
        if authStep.config.ugTELCO == true, let ugTELCO = govtDataConfig.ugTelco {
            governmentIDs.append(ugTELCO)
        }
        
        if authStep.config.keDL == true, let keDL = govtDataConfig.keDL {
            governmentIDs.append(keDL)
        }
        
        if authStep.config.keID == true, let keID = govtDataConfig.keID {
            governmentIDs.append(keID)
        }
        
        if authStep.config.keKRA == true, let keKRA = govtDataConfig.keKRA {
            governmentIDs.append(keKRA)
        }
        
        if authStep.config.saDL == true, let saDL = govtDataConfig.saDL {
            governmentIDs.append(saDL)
        }
        
        if authStep.config.saID == true, let saID = govtDataConfig.saID {
            governmentIDs.append(saID)
        }
        
        if authStep.config.cac == true, let cac = govtDataConfig.cac {
            governmentIDs.append(cac)
        }
        
        //Verification Methods
        if authStep.config.selfie == true, let selfieConfig = govtDataConfig.selfie {
            governmentIDVerificationMethods.append(selfieConfig)
        }
        
        if authStep.config.otp == true, let otpConfig = govtDataConfig.otp {
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
            sendVerificationMethodSelectedEvent()
        }
    }
    
    private func sendVerificationMethodSelectedEvent() {
        
    }
}
