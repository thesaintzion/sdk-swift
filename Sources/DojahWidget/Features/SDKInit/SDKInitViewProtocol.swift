//
//  SDKInitViewProtocol.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation

protocol SDKInitViewProtocol: AnyObject {
    func showLoader(_ show: Bool)
    func showSDKInitFailedView()
    func showDisclaimer()
    func showCountryNotSupportedError()
    func showVerificationSuccessful()
}
