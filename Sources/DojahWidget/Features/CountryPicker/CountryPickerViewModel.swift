//
//  CountryPickerViewModel.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

final class CountryPickerViewModel: BaseViewModel {
    private let countriesLocalDatasource: CountriesLocalDatasourceProtocol
    var countries = [DJCountryDB]()
    var countryNames: [String] {
        countries.map { "\($0.emoticon)  \($0.countryName)" }
    }
    private var countrySelected = false
    
    init(countriesLocalDatasource: CountriesLocalDatasourceProtocol = CountriesLocalDatasource()) {
        self.countriesLocalDatasource = countriesLocalDatasource
        countries = countriesLocalDatasource.getCountries()
        super.init()
        preference.DJCountryCode = "NG"
    }
    
    func country(at index: Int) -> DJCountryDB {
        countries[index]
    }
    
    func didSelectCountry(at index: Int) {
        countrySelected = true
        let country = country(at: index)
        preference.DJCountryCode = country.iso2
        postEvent(
            request: .init(name: .countrySelected, value: country.countryName),
            showLoader: false,
            showError: false
        )
    }
    
    func didTapContinue() {
        if !countrySelected {
            postEvent(
                request: .init(name: .countrySelected, value: "Nigeria"),
                showLoader: false,
                showError: false
            )
        }
        postEvent(
            request: .init(name: .stepCompleted, value: "countries"),
            didSucceed: { [weak self] _ in
                self?.countrySelected = false
                runAfter {
                    self?.setNextAuthStep()
                }
            },
            didFail: { [weak self] _ in
                self?.countrySelected = false
                kprint("unable to post step_completed for countries")
            }
        )
    }
}
