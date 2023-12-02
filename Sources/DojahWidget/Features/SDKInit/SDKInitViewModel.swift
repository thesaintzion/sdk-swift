//
//  SDKInitViewModel.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation

final class SDKInitViewModel {
    
    weak var viewProtocol: SDKInitViewProtocol?
    private let widgetID: String
    private var preference: PreferenceProtocol
    private let countriesDatasource: CountriesLocalDatasourceProtocol
    private let authenticationRemoteDatasource: AuthenticationRemoteDatasourceProtocol
    
    init(
        widgetID: String,
        preference: PreferenceProtocol = PreferenceImpl(),
        countriesDatasource: CountriesLocalDatasourceProtocol = CountriesLocalDatasource(),
        authenticationRemoteDatasource: AuthenticationRemoteDatasourceProtocol = AuthenticationRemoteDatasource()
    ) {
        self.widgetID = widgetID
        self.preference = preference
        self.preference.widgetID = widgetID
        self.countriesDatasource = countriesDatasource
        self.authenticationRemoteDatasource = authenticationRemoteDatasource
    }
    
    func initialize() {
        viewProtocol?.showLoader(true)
        guard !preference.countriesInitialized, let jsonData = jsonData(from: "countries") else {
            preAuthenticate()
            return
        }
        
        do {
            let countries = try jsonData.decode(into: [DJCountry].self)
            let dbCountries = countries.map { $0.countryDB }
            try countriesDatasource.saveCountries(dbCountries)
            preference.countriesInitialized = true
            preAuthenticate()
        } catch {
            kprint("\(error)")
            viewProtocol?.showSDKInitFailedView()
        }
    }
    
    private func preAuthenticate() {
        
    }
}
