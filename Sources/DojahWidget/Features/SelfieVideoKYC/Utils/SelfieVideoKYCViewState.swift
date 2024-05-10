//
//  SelfieVideoKYCViewState.swift
//
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import Foundation

enum SelfieVideoKYCViewState {
    case capture
    case record
    case previewSelfie
    case previewSelfieVideo
    
    var primaryButtonTitle: String {
        switch self {
        case .capture:
            return "Capture"
        case .record:
            return "Record"
        case .previewSelfie, .previewSelfieVideo:
            return "Continue"
        }
    }
    
    var hintText: String {
        switch self {
        case .capture:
            return "Place your face in the circle and click Capture"
        case .record:
            return "Place your face in the circle and click Record"
        case .previewSelfie:
            return "Preview your selfie"
        case .previewSelfieVideo:
            return "Preview your selfie video"
        }
    }
}
