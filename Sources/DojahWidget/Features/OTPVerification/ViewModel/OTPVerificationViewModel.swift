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
        preference.DJOTPVerificationInfo
    }
    var otp = ""
    private var otpReference = ""
    
    init(otpRemoteDatasource: OTPRemoteDatasourceProtocol = OTPRemoteDatasource()) {
        self.otpRemoteDatasource = otpRemoteDatasource
        super.init()
    }
    
    func requestOTP() {
        showLoader?(true)
        let params: DJParameters = [
            "destination": preference.DJOTPVerificationInfo,
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
                    self?.viewProtocol?.startCountdownTimer()
                } else {
                    self?.showErrorMessage("Unable to request for OTP")
                }
            case let .failure(error):
                self?.showErrorMessage(error.localizedDescription)
            }
        }
    }
    
    func verifyOTP() {
        showLoader?(true)
        let params = [
            "code": otp,
            "reference_id": otpReference
        ]
        otpRemoteDatasource.validateOTP(params: params) { [weak self] result in
            self?.showLoader?(false)
            switch result {
            case let .success(entityResponse):
                if entityResponse.entity?.valid ?? false {
                    self?.viewProtocol?.showSuccess()
                } else {
                    self?.showErrorMessage("Unable to verify OTP, please try again")
                }
            case let .failure(error):
                self?.showErrorMessage(error.localizedDescription)
            }
        }
    }
    
    private func showErrorMessage(_ message: String) {
        showMessage?(
            .error(
                message: message,
                doneAction: { [weak self] in
                    //self?.viewProtocol?.errorAction()
                }
            )
        )
    }
}
