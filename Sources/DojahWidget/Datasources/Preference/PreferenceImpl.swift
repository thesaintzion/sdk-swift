//
//  PreferenceImpl.swift
//  
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation

struct PreferenceImpl: PreferenceProtocol {
    @UserDefaultPrimitive(key: .DJWidgetID, default: "")
    var DJWidgetID: String
    
    @UserDefaultPrimitive(key: .DJCountriesInitialized, default: false)
    var DJCountriesInitialized: Bool
    
    @UserDefaultCodable(key: .DJAppConfig, default: nil)
    var DJAppConfig: DJAppConfig?
    
    @UserDefaultCodable(key: .DJRequestHeaders, default: [:])
    var DJRequestHeaders: DJHeaderParameters
    
    @UserDefaultPrimitive(key: .DJUserAgent, default: "")
    var DJUserAgent: String
    
    @UserDefaultPrimitive(key: .DJIPCountry, default: "")
    var DJIPCountry: String
    
    @UserDefaultPrimitive(key: .DJCanSeeCountryPage, default: false)
    var DJCanSeeCountryPage: Bool
}
