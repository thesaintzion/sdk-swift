//
//  DJCountry.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation

struct DJCountry: Codable {
    let countryName, iso2, iso3, topLevelDomain: String
    let fips: String
    let isoNumeric, geoNameID: StringOrIntEnum
    let e164: Int
    let phoneCode: StringOrIntEnum
    let continent: Continent
    let capital, timeZoneInCapital, currency, languageCodes: String
    let languages: String
    let areaKM2: Int
    let internetHosts, internetUsers, phonesMobile, phonesLandline: StringOrIntEnum
    let gdp: StringOrIntEnum

    enum CodingKeys: String, CodingKey {
        case countryName = "Country Name"
        case iso2 = "ISO2"
        case iso3 = "ISO3"
        case topLevelDomain = "Top Level Domain"
        case fips = "FIPS"
        case isoNumeric = "ISO Numeric"
        case geoNameID = "GeoNameID"
        case e164 = "E164"
        case phoneCode = "Phone Code"
        case continent = "Continent"
        case capital = "Capital"
        case timeZoneInCapital = "Time Zone in Capital"
        case currency = "Currency"
        case languageCodes = "Language Codes"
        case languages = "Languages"
        case areaKM2 = "Area KM2"
        case internetHosts = "Internet Hosts"
        case internetUsers = "Internet Users"
        case phonesMobile = "Phones (Mobile)"
        case phonesLandline = "Phones (Landline)"
        case gdp = "GDP"
    }
    
    var countryDB: DJCountryDB {
        DJCountryDB(
            iso2: iso2,
            countryName: countryName,
            iso3: iso3,
            topLevelDomain: topLevelDomain,
            fips: fips,
            isoNumeric: isoNumeric.value,
            geoNameID: geoNameID.value,
            e164: e164,
            phoneCode: phoneCode.value,
            continent: continent.rawValue,
            capital: capital,
            timeZoneInCapital: timeZoneInCapital,
            currency: currency,
            languageCodes: languageCodes,
            languages: languages,
            areaKM2: areaKM2,
            internetHosts: internetHosts.value,
            internetUsers: internetUsers.value,
            phonesMobile: phonesMobile.value,
            phonesLandline: phonesLandline.value,
            gdp: gdp.value
        )
    }
}

enum Continent: String, Codable {
    case africa = "Africa"
    case antarctica = "Antarctica"
    case asia = "Asia"
    case europe = "Europe"
    case northAmerica = "North America"
    case oceania = "Oceania"
    case southAmerica = "South America"
}

enum StringOrIntEnum: Codable {
    case integer(Int)
    case string(String)
    
    var value: String {
        switch self {
        case .integer(let value):
            return value.string
        case .string(let value):
            return value
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(StringOrIntEnum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for StringOrIntEnum"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
