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
    private var destination: String = ""
    
    init(
        destination: String = "",
        otpRemoteDatasource: OTPRemoteDatasourceProtocol = OTPRemoteDatasource()
    ) {
        self.otpRemoteDatasource = otpRemoteDatasource
        super.init()
        self.destination = destination.isEmpty ? preference.DJOTPVerificationInfo : destination
    }
    
    func requestOTP() {
        showLoader?(true)
        hideMessage()
        let params: DJParameters = [
            "destination": destination,
            "length" : 4,
            "channel" : "sms",
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
                    self?.postStepCompletedEvent()
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
    
    private func postStepCompletedEvent() {
        postEvent(
            request: .event(name: .stepCompleted, pageName: .governmentDataVerification),
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
