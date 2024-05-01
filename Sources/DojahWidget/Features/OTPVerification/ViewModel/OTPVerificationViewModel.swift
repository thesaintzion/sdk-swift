//
//  OTPVerificationViewModel.swift
//
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import Foundation

final class OTPVerificationViewModel: BaseViewModel {
    private let verificationMethod: GovtIDVerificationMethod = .phoneNumberOTP
    weak var viewProtocol: VerifyOTPViewProtocol?
    private let otpRemoteDatasource: OTPRemoteDatasourceProtocol
    var isPhoneNumberVerification: Bool {
        verificationMethod == .phoneNumberOTP
    }
    var verificationInfo: String {
        let lastDigits = String(preference.DJOTPVerificationInfo.suffix(4))
        return "XXXXXXX\(lastDigits)"
    }
    var otp = ""
    private var otpReference = ""
    private var otpRequestChannel: Any {
        if preference.DJAuthStep.name == .phoneNumber {
            return ["sms", "whatsapp", "voice"]
        } else {
            return "sms"
        }
    }
    
    init(otpRemoteDatasource: OTPRemoteDatasourceProtocol = OTPRemoteDatasource()) {
        self.otpRemoteDatasource = otpRemoteDatasource
        super.init()
    }
    
    func requestOTP() {
        showLoader?(true)
        hideMessage()
        let params: DJParameters = [
            "destination": preference.DJOTPVerificationInfo,
            "length" : 4,
            "channel" : otpRequestChannel,
            "sender_id": "kedesa",
            "priority": true
        ]
        
        otpRemoteDatasource.requestOTP(params: params) { [weak self] result in
            self?.showLoader?(false)
            switch result {
            case let .success(entityResponse):
                if let response = entityResponse.entity, let otpReference = response.first?.referenceID {
                    self?.otpReference = otpReference
                    runAfter(0.15) {
                        self?.viewProtocol?.startCountdownTimer()
                    }
                } else {
                    self?.showErrorMessage(DJSDKError.OTPCouldNotBeSent.uiMessage)
                }
            case .failure:
                self?.showErrorMessage(DJSDKError.OTPCouldNotBeSent.uiMessage)
            }
        }
    }
    
    func verifyOTP() {
        showLoader?(true)
        hideMessage()
        let params = [
            "code": otp,
            "reference_id": otpReference
        ]
        otpRemoteDatasource.validateOTP(params: params) { [weak self] result in
            self?.showLoader?(false)
            switch result {
            case let .success(entityResponse):
                if entityResponse.entity?.valid ?? false {
                    self?.didVerifyOTP()
                } else {
                    self?.sendStepFailedEventForInvalidOTP()
                    self?.showErrorMessage(DJSDKError.invalidOTPEntered.uiMessage)
                }
            case let .failure(error):
                self?.sendStepFailedEventForInvalidOTP()
                self?.showErrorMessage(error.uiMessage)
            }
        }
    }
    
    private func didVerifyOTP() {
        if preference.DJAuthStep.name == .phoneNumber {
            logPhoneNumberValidationEvent()
        } else {
            postStepCompletedEvent()
        }
    }
    
    private func logPhoneNumberValidationEvent() {
        postEvent(
            request: .init(name: .phoneNumberValidation, value: "\(preference.DJOTPVerificationInfo),Successful"),
            showLoader: true,
            showError: true,
            didSucceed: { [weak self] _ in
                self?.postStepCompletedEvent()
            }, didFail: { [weak self] _ in
                self?.postStepCompletedEvent()
            }
        )
    }
    
    private func postStepCompletedEvent() {
        postEvent(
            request: .event(name: .stepCompleted, pageName: preference.DJAuthStep.name),
            showLoader: false,
            showError: false,
            didSucceed: { [weak self] _ in
                runAfter { [weak self] in
                    self?.setNextAuthStep()
                }
            }, didFail: { [weak self] _ in
                runAfter { [weak self] in
                    self?.setNextAuthStep()
                }
            }
        )
    }
    
    private func sendStepFailedEventForInvalidOTP() {
        postEvent(
            request: .stepFailed(errorCode: .invalidOTP),
            showLoader: false,
            showError: false
        )
    }
    
    private func hideMessage() {
        runOnMainThread { [weak self] in
            self?.viewProtocol?.hideMessage()
        }
    }
    
    private func showErrorMessage(_ message: String) {
        showLoader?(false)
        runOnMainThread { [weak self] in
            self?.viewProtocol?.showErrorMessage(message)
        }
    }
}
