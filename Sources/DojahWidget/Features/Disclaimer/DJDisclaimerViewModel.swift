//
//  DJDisclaimerViewModel.swift
//
//
//  Created by Isaac Iniongun on 07/12/2023.
//

import Foundation

final class DJDisclaimerViewModel {
    private let preference: PreferenceProtocol
    var canSeeCountryPage: Bool {
        preference.DJCanSeeCountryPage
    }
    
    init(preference: PreferenceProtocol = PreferenceImpl()) {
        self.preference = preference
    }
}
