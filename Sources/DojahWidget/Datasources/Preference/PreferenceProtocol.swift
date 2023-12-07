//
//  PreferenceProtocol.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation

protocol PreferenceProtocol {
    var DJWidgetID: String { get set }
    var DJCountriesInitialized: Bool { get set }
    var DJAppConfig: DJAppConfig? { get set }
    var DJRequestHeaders: DJHeaderParameters { get set }
    var DJUserAgent: String { get set }
    var DJIPCountry: String { get set }
}
