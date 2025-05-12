//
//  DojahWidgetSDK.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation
import UIKit

public final class DojahWidgetSDK {
    public static func initializeNormal(
        widgetID: String,
        referenceID: String? = nil,
        emailAddress: String? = nil,
        uiController: UIViewController
    ) {
        let viewModel = SDKInitViewModel(
            widgetID: widgetID,
            referenceID: referenceID,
            emailAddress: emailAddress
        )

        let controller = SDKInitViewController(viewModel: viewModel)
        uiController.present(controller,animated: true, completion: { result in
            switch result {
            case .success(let result):
                print("Success: \(result)")
            case .failure(let error):
                print("Error: \(error)")
            }
        })
//        uiController.show(controller, sender: true)
    }
    
    public static func initialize(
        widgetID: String,
        referenceID: String? = nil,
        emailAddress: String? = nil,
        navController: UINavigationController
    ) {
        let viewModel = SDKInitViewModel(
            widgetID: widgetID,
            referenceID: referenceID,
            emailAddress: emailAddress
        )
        let controller = SDKInitViewController(viewModel: viewModel)
        navController.pushViewController(controller, animated: true, completion: { result in
            switch result {
            case .success(let result):
                print("Success: \(result)")
            case .failure(let error):
                print("Error: \(error)")
            }
        })
    }

    public static func getCachedWidgetIDs() -> [WidgetIDCache] {
        preference.WidgetIDCache
    }
}
