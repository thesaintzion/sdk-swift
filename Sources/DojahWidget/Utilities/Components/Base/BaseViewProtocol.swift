//
//  BaseViewProtocol.swift
//
//
//  Created by Isaac Iniongun on 08/12/2023.
//

import Foundation

protocol BaseViewProtocol: AnyObject {
    func showLoader(_ show: Bool)
    func showMessage(config: FeedbackConfig)
}
