//
//  PreferenceImpl.swift
//  
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation

struct PreferenceImpl: PreferenceProtocol {
    @UserDefaultPrimitive(key: .widgetID, default: "")
    var widgetID: String
    
    @UserDefaultPrimitive(key: .countriesInitialized, default: false)
    var countriesInitialized: Bool
}
