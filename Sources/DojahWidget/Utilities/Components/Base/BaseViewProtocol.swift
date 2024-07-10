//
//  BaseViewProtocol.swift
//
//
//  Created by Isaac Iniongun on 08/12/2023.
//

import Foundation

protocol BaseViewProtocol: AnyObject {
    func errorDoneAction()
    func showErrorMessage(_ message: String)
    func showSuccessMessage(_ message: String)
    func hideMessage()
}

extension BaseViewProtocol {
    func errorDoneAction() {}
    func showErrorMessage(_ message: String) {}
    func showSuccessMessage(_ message: String) {}
    func hideMessage() {}
}
