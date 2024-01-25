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
            self?.showLoader?(false)
            switch res {
            case .success(let res):
                if res.entity?.success == true {
                    self?.setNextAuthStep()
                } else {
                    self?.showErrorMessage(res.entity?.msg ?? DJConstants.genericErrorMessage)
                }
            case .failure(let error):
                self?.showErrorMessage(error.localizedDescription)
            }
        }
    }
}
