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
    
    @UserDefaultPrimitive(key: .DJConfigurationInitialized, default: false)
    var DJConfigurationInitialized: Bool
    
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
    
    @UserDefaultPrimitive(key: .DJVerificationID, default: 0)
    var DJVerificationID: Int
    
    @UserDefaultCodable(key: .DJSteps, default: [])
    var DJSteps: [DJAuthStep]
    
    @UserDefaultCodable(key: .DJAuthStep, default: .index)
    var DJAuthStep: DJAuthStep
    
    @UserDefaultCodable(key: .DJGovernmentIDConfig, default: nil)
    var DJGovernmentIDConfig: DJGovernmentIDConfig?
}
