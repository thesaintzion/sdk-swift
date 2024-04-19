//
//  CountryPickerViewProtocol.swift
//
//
//  Created by Isaac Iniongun on 13/03/2024.
//

import Foundation

protocol CountryPickerViewProtocol: BaseViewProtocol {
    func refreshCountries()
    func enableContinueButton(_ enable: Bool)
}
