//
//  File.swift
//  
//
//  Created by Isaac Iniongun on 25/01/2024.
//

import Foundation

final class UserDataViewModel: BaseViewModel {
    weak var viewProtocol: UserDataViewProtocol?
    private let remoteDatasource: UserDataRemoteDatasourceProtocol
    
    init(remoteDatasource: UserDataRemoteDatasourceProtocol = UserDataRemoteDatasource()) {
        self.remoteDatasource = remoteDatasource
        super.init()
    }
    
    func saveUserData(
        firstName: String,
        middleName: String,
        lastName: String,
        dob: String
    ) {
        let params: DJParameters = [
            "mobile": "",
            "country": preference.DJCountryCode,
            "residence_country": preference.DJCountryCode,
            "first_name": firstName,
            "middle_name": middleName,
            "last_name": lastName,
            "dob": dob,
            "step_number": preference.DJAuthStep.id
        ]
        
        showLoader?(true)
        remoteDatasource.saveUserData(params: params) { [weak self] res in
            switch res {
            case .success(let res):
                if res.entity?.success == true {
                    self?.postStepCompletedEvent()
                } else {
                    self?.showErrorMessage(res.entity?.msg ?? DJConstants.genericErrorMessage) {
                        self?.postStepFailedEvent()
                    }
                }
            case .failure(let error):
                self?.showErrorMessage(error.localizedDescription) {
                    self?.postStepFailedEvent()
                }
            }
        }
    }
    
    private func postStepCompletedEvent() {
        postEvent(
            request: .event(name: .stepCompleted, pageName: .userData),
            showLoader: false,
            showError: false,
            didSucceed: { [weak self] eventRes in
                self?.showLoader?(false)
                self?.setNextAuthStep()
            },
            didFail: { [weak self] error in
                kprint("couldn't post 'user-data' event")
                self?.showLoader?(false)
                self?.setNextAuthStep()
            }
        )
    }
    
    private func postStepFailedEvent() {
        postEvent(
            request: .event(name: .stepFailed, pageName: .userData),
            showError: false,
            didSucceed: { [weak self] _ in
                self?.errorDoneAction?()
            },
            didFail: { [weak self] _ in
                self?.errorDoneAction?()
            }
        )
    }
}
