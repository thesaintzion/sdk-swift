//
//  DojahWidgetSDK.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation
import UIKit

public final class DojahWidgetSDK {
    public static func initialize(widgetID: String, navController: UINavigationController) {
        let viewModel = SDKInitViewModel(widgetID: widgetID)
        let controller = SDKInitViewController(viewModel: viewModel)
        navController.pushViewController(controller, animated: true)
    }
}
