//
//  SelfieVideoKYCViewState.swift
//
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import Foundation

enum SelfieVideoKYCViewState {
    case captureRecord
    case preview //titleText
    
    var primaryButtonTitle: String {
        switch self {
        case .captureRecord:
            return "Capture"
        case .preview:
            return "Continue"
        }
    }
    
    var hintText: String {
        switch self {
        case .captureRecord:
            return "Place your face in the circle and click Capture"
        case .preview:
            return "Preview your selfie"
        }
    }
}
