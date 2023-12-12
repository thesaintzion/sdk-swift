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
    
    init(countriesLocalDatasource: CountriesLocalDatasourceProtocol = CountriesLocalDatasource()) {
        self.countriesLocalDatasource = countriesLocalDatasource
        countries = countriesLocalDatasource.getCountries()
        super.init()
    }
    
    func country(at index: Int) -> DJCountryDB {
        countries[index]
    }
    
    func didSelectCountry(at index: Int) {
        let countryName = country(at: index).countryName
        postEvent(
            request: .init(name: .countrySelected, value: countryName),
            showLoader: false,
            showError: false
        )
    }
    
    func didTapContinue() {
        postEvent(
            request: .init(name: .stepCompleted, value: "countries"),
            didSucceed: { [weak self] _ in
                self?.setNextAuthStep()
            }, 
            didFail: { _ in
                kprint("unable to post step_completed for countries")
            }
        )
    }
}
