//
//  PermissionType.swift
//
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

enum PermissionType: String {
    case camera = "Camera", location = "Location"
    
    var icon: UIImage {
        switch self {
        case .camera:
            return .res("cameraPermission")
        case .location:
            return .res("locationPermission")
        }
    }
    
    var disclaimerItems: [String] {
        switch self {
        case .camera:
            return DJConstants.idCaptureDisclaimerItems
        case .location:
            return DJConstants.locationDisclaimerItems
        }
    }
}
