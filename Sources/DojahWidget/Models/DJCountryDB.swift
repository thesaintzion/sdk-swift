//
//  DJCountryDB.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation
import RealmSwift
import UIKit

class DJCountryDB: Object {
    @Persisted(primaryKey: true) var iso2: String
    @Persisted var countryName: String
    @Persisted var iso3: String
    @Persisted var topLevelDomain: String
    @Persisted var fips: String
    @Persisted var isoNumeric: String
    @Persisted var geoNameID: String
    @Persisted var e164: Int
    @Persisted var phoneCode: String
    @Persisted var continent: String
    @Persisted var capital: String
    @Persisted var timeZoneInCapital: String
    @Persisted var currency: String
    @Persisted var languageCodes: String
    @Persisted var languages: String
    @Persisted var areaKM2: Int
    @Persisted var internetHosts: String
    @Persisted var internetUsers: String
    @Persisted var phonesMobile: String
    @Persisted var phonesLandline: String
    @Persisted var gdp: String
    
    convenience init(
        iso2: String,
        countryName: String,
        iso3: String,
        topLevelDomain: String,
        fips: String,
        isoNumeric: String,
        geoNameID: String,
        e164: Int,
        phoneCode: String,
        continent: String,
        capital: String,
        timeZoneInCapital: String,
        currency: String,
        languageCodes: String,
        languages: String,
        areaKM2: Int,
        internetHosts: String,
        internetUsers: String,
        phonesMobile: String,
        phonesLandline: String,
        gdp: String
    ) {
        self.init()
        self.iso2 = iso2
        self.countryName = countryName
        self.iso3 = iso3
        self.topLevelDomain = topLevelDomain
        self.fips = fips
        self.isoNumeric = isoNumeric
        self.geoNameID = geoNameID
        self.e164 = e164
        self.phoneCode = phoneCode
        self.continent = continent
        self.capital = capital
        self.timeZoneInCapital = timeZoneInCapital
        self.currency = currency
        self.languageCodes = languageCodes
        self.languages = languages
        self.areaKM2 = areaKM2
        self.internetHosts = internetHosts
        self.internetUsers = internetUsers
        self.phonesMobile = phonesMobile
        self.phonesLandline = phonesLandline
        self.gdp = gdp
    }
    
    var flag: UIImage {
        UIImage(named: iso2.lowercased(), in: DojahBundle.bundle, compatibleWith: nil) ?? .res("ng")
    }
    
    var emoticon: String {
        let baseFlagScalar: UInt32 = 127397
        var flagString = ""
        for scalarValue in iso2.uppercased().unicodeScalars {
            guard let scalar = UnicodeScalar(baseFlagScalar + scalarValue.value) else {
                continue
            }
            flagString.unicodeScalars.append(scalar)
        }
        return flagString
    }
    
    var emoticonCountryName: String {
        "\(emoticon)  \(countryName)"
    }
}

extension [DJCountryDB] {
    var emoticonPhoneCodes: [String] {
        map { "\($0.emoticon) \($0.phoneCode)(\($0.iso2))" }
    }
}
