//
//  PhoneNumberViewModel.swift
//
//
//  Created by Isaac Iniongun on 01/05/2024.
//

import Foundation

final class PhoneNumberViewModel: BaseViewModel {
    weak var viewProtocol: PhoneNumberViewProtocol?
    private let countriesLocalDatasource: CountriesLocalDatasourceProtocol
    var countries = [DJCountryDB]()
    private var selectedCountry: DJCountryDB?
    private var number: String = ""
    
    init(countriesLocalDatasource: CountriesLocalDatasourceProtocol = CountriesLocalDatasource()) {
        self.countriesLocalDatasource = countriesLocalDatasource
        countries = countriesLocalDatasource.getCountries().sorted { $0.phoneCode < $1.phoneCode }
        super.init()
    }
    
    func didChooseCountry(index: Int) {
        guard index >= 0, index < countries.count else { return }
        selectedCountry = countries[index]
        guard let selectedCountry else { return }
        viewProtocol?.updateCountryDetails(
            phoneCode: selectedCountry.phoneCode,
            flag: selectedCountry.flag
        )
    }
    
    func numberDidChange(_ number: String) {
        self.number = number
        viewProtocol?.enableContinueButton(self.number.isNotEmpty)
    }
    
    func didTapContinue() {
        preference.DJOTPVerificationInfo = number
        if preference.DJAuthStep.config?.verification ?? false {
            viewProtocol?.showVerifyController()
        } else {
            logPhoneNumberValidationEvent()
        }
    }
    
    private func logPhoneNumberValidationEvent() {
        postEvent(
            request: .init(name: .phoneNumberValidation, value: "\(number),Successful"),
            showLoader: true,
            showError: true,
            didSucceed: { [weak self] _ in
                self?.logStepCompleted()
            }, didFail: { [weak self] _ in
                self?.logStepCompleted()
            }
        )
    }
    
    private func logStepCompleted() {
        postEvent(
            request: .event(name: .stepCompleted, pageName: .phoneNumber),
            showLoader: false,
            showError: false
        )
        runAfter { [weak self] in
            self?.setNextAuthStep()
        }
    }
}
