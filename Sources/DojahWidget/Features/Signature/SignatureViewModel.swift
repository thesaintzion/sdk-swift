//
//  SignatureViewModel.swift
//
//
//  Created by Isaac Iniongun on 13/02/2024.
//

import Foundation

final class SignatureViewModel: BaseViewModel {
    lazy var signatureInformation = preference.DJAuthStep.config?.information ?? ""
    
    func confirm(name: String) {
        postEvent(
            request: .event(name: .stepCompleted, pageName: .signature),
            showLoader: false,
            showError: false
        )
        let eventValue = "\(name)|\(signatureInformation.replacingOccurrences(of: "|", with: ""))"
        postEvent(
            request: .init(name: .signature, value: eventValue),
            showLoader: false,
            didSucceed: { [weak self] _ in
                runAfter { [weak self] in
                    self?.setNextAuthStep()
                }
            },
            didFail: { [weak self] _ in
                runAfter { [weak self] in
                    self?.setNextAuthStep()
                }
            }
        )
    }
}
