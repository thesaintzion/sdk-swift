//
//  CountryPickerViewModel.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

final class CountryPickerViewModel {
    private let countriesLocalDatasource: CountriesLocalDatasourceProtocol
    var countries = [DJCountryDB]()
    var countryNames: [String] {
        countries.map { "\($0.emoticon)  \($0.countryName)" }
    }
    
    init(countriesLocalDatasource: CountriesLocalDatasourceProtocol = CountriesLocalDatasource()) {
        self.countriesLocalDatasource = countriesLocalDatasource
        countries = countriesLocalDatasource.getCountries()
    }
    
    func getCountry(name: String) -> DJCountryDB? {
        guard let kname = name.components(separatedBy: .whitespaces).last else { return nil }
        return countries.first { $0.countryName.insensitiveEquals(kname) }
    }
    
    func country(at index: Int) -> DJCountryDB {
        countries[index]
    }
}
