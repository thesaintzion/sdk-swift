//
//  CountryPickerViewModel.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

final class CountryPickerViewModel: BaseViewModel {
    weak var viewProtocol: CountryPickerViewProtocol?
    private let countriesLocalDatasource: CountriesLocalDatasourceProtocol
    private var allCountries = [DJCountryDB]()
    var countries = [DJCountryDB]()
    //TODO: Remove this code after country selection tests have been confirmed
    /*var countryNames: [String] {
        countries.map { "\($0.emoticon)  \($0.countryName)" }
    }*/
    private var countrySelected = false
    private var selectedCountry: DJCountryDB?
    
    init(countriesLocalDatasource: CountriesLocalDatasourceProtocol = CountriesLocalDatasource()) {
        self.countriesLocalDatasource = countriesLocalDatasource
        allCountries = countriesLocalDatasource.getCountries()
        countries = allCountries
        super.init()
        preference.DJCountryCode = "NG"
    }
    
    //TODO: Remove this code after country selection tests have been confirmed
    /*func country(at index: Int) -> DJCountryDB {
        countries[index]
    }*/
    
    func filterCountries(_ text: String) {
        if text.isEmpty {
            countries = allCountries
        } else {
            countries = allCountries.filter {
                $0.countryName.insensitiveContains(text) ||
                $0.iso2.insensitiveContains(text) ||
                $0.iso3.insensitiveContains(text)
            }
        }
        viewProtocol?.refreshCountries()
    }
    
    func didChooseCountry(_ country: DJCountryDB) {
        countrySelected = true
        preference.DJCountryCode = country.iso2
        postEvent(
            request: .init(name: .countrySelected, value: country.countryName),
            showLoader: false,
            showError: false
        )
        countries = allCountries
    }
    
    //TODO: Remove this code after country selection tests have been confirmed
    /*func didSelectCountry(at index: Int) {
        countrySelected = true
        let country = country(at: index)
        preference.DJCountryCode = country.iso2
        postEvent(
            request: .init(name: .countrySelected, value: country.countryName),
            showLoader: false,
            showError: false
        )
    }*/
    
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
