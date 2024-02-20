//
//  DJGovernmentDataViewModel.swift
//
//
//  Created by Isaac Iniongun on 12/12/2023.
//

import Foundation

final class DJGovernmentDataViewModel: BaseViewModel {
    weak var viewProtocol: GovernmentDataViewProtocol?
    private let governmentDataRemoteDatasource: GovernmentDataRemoteDatasourceProtocol
    var governmentIDs = [DJGovernmentID]()
    var governmentIDVerificationMethods = [DJGovernmentID]()
    var selectedGovernmentID: DJGovernmentID?
    var selectedGovernmentIDVerificationMethod: DJGovernmentID?
    var idNumber = ""
    private var lookupEntity: GovernmentDataLookupEntity? = nil
    
    init(remoteDatasource: GovernmentDataRemoteDatasourceProtocol = GovernmentDataRemoteDatasource()) {
        self.governmentDataRemoteDatasource = remoteDatasource
        super.init()
    }
    
    func getGovernmentIDConfiguration() {
        guard let govtDataConfig = preference.DJGovernmentIDConfig else { return }
        let authStep = preference.DJAuthStep
        
        governmentIDs = GovernmentIDFactory.getGovernmentIDs(preference: preference)
        
        // Identification Methods
        /*if authStep.config.bvn == true, let bvnConfig = govtDataConfig.bvn {
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
        }*/
        
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
            selectedGovernmentIDVerificationMethod = governmentIDVerificationMethods[index]
            preference.DJSelectedGovernmentIDVerificationMethod = selectedGovernmentIDVerificationMethod
            sendVerificationMethodSelectedEvent()
        }
    }
    
    private func sendVerificationMethodSelectedEvent() {
        guard let modeParam = selectedGovernmentIDVerificationMethod?.verificationModeParam else { return }
        postEvent(
            request: .init(name: .verificationModeSelected, value: modeParam),
            showLoader: false,
            showError: false
        )
    }
    
    func didTapContinue() {
        guard let selectedGovernmentID else { return }
        showLoader?(true)
        let eventRequest = DJEventRequest(
            name: .verificationTypeSelected,
            value: "\(selectedGovernmentID.idTypeParam),\(idNumber)"
        )
        eventsRemoteDatasource.postEvent(request: eventRequest) { [weak self] result in
            switch result {
            case let .success(successResponse):
                if successResponse.entity?.success ?? false {
                    self?.lookupGovernmentData()
                } else {
                    self?.showErrorMessage(successResponse.entity?.msg ?? "Unable to send verificationTypeSelected event")
                }
            case let .failure(error):
                self?.showErrorMessage(error.uiMessage)
            }
        }
    }
    
    private func lookupGovernmentData() {
        guard let idEnum = selectedGovernmentID?.idEnum, let idType = DJGovernmentIDType(rawValue: idEnum) else { return }
        governmentDataRemoteDatasource.lookupID(number: idNumber, idType: idType) { [weak self] result in
            switch result {
            case let .success(lookupResponse):
                if let response = lookupResponse.entity {
                    self?.lookupEntity = response
                    self?.postGovernmentDataCollectedEvent()
                } else {
                    self?.showErrorMessage("Unable to lookup Government Data, please try again")
                }
            case let .failure(error):
                self?.showErrorMessage(error.uiMessage)
            }
        }
    }
    
    private func showErrorMessage(_ message: String) {
        showLoader?(false)
        showMessage?(
            .error(
                message: message,
                doneAction: { [weak self] in
                    self?.viewProtocol?.errorAction()
                }
            )
        )
    }
    
    private func postGovernmentDataCollectedEvent() {
        guard let lookupEntity, let selectedGovernmentID else { return }
        let eventRequest = DJEventRequest(
            name: .customerGovernmentDataCollected,
            value: lookupEntity.dataCollectedParam(
                idEnum: selectedGovernmentID.idEnum.orEmpty,
                countryCode: preference.DJCountryCode
            )
        )
        eventsRemoteDatasource.postEvent(request: eventRequest) { [weak self] result in
            switch result {
            case let .success(successResponse):
                if successResponse.entity?.success ?? false {
                    self?.postGovernmentImageCollectedEvent()
                } else {
                    self?.showErrorMessage(successResponse.entity?.msg ?? "Unable to send customerGovernmentDataCollected event")
                }
            case let .failure(error):
                self?.showErrorMessage(error.uiMessage)
            }
        }
    }
    
    private func postGovernmentImageCollectedEvent() {
        guard let lookupEntity, let image = lookupEntity.image ?? lookupEntity.photo else { return }
        eventsRemoteDatasource.postEvent(request: .init(name: .governmentImageCollected, value: image)) { [weak self] result in
            switch result {
            case let .success(successResponse):
                if successResponse.entity?.success ?? false {
                    self?.postStepCompletedEvent()
                } else {
                    self?.showErrorMessage(successResponse.entity?.msg ?? "Unable to send governmentImageCollected event")
                }
            case let .failure(error):
                self?.showErrorMessage(error.uiMessage)
            }
        }
    }
    
    private func postStepCompletedEvent() {
        eventsRemoteDatasource.postEvent(request: .init(name: .stepCompleted, value: "government-data")) { [weak self] result in
            switch result {
            case let .success(successResponse):
                if successResponse.entity?.success ?? false {
                    self?.didSendCompletedEvent()
                } else {
                    self?.showErrorMessage(successResponse.entity?.msg ?? "Unable to send stepCompleted::government-data event")
                }
            case let .failure(error):
                self?.showErrorMessage(error.uiMessage)
            }
        }
    }
    
    private func didSendCompletedEvent() {
        showLoader?(false)
        if selectedGovernmentIDVerificationMethod?.verificationModeParam == "OTP" {
            guard let lookupEntity,
                  let phoneNumber = lookupEntity.phoneNumber1 ?? lookupEntity.phoneNumber2
            else { return }
            preference.DJOTPVerificationInfo = phoneNumber
        }
        runAfter { [weak self] in
            self?.setNextAuthStep()
        }
    }
}
