//
//  CountriesLocalDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation

protocol CountriesLocalDatasourceProtocol {
    func saveCountries(_ countries: [DJCountryDB]) throws
    func getCountries() -> [DJCountryDB]
    func getCountry(iso2: String) -> DJCountryDB?
    func getCountryByName(_ name: String) -> DJCountryDB?
}
