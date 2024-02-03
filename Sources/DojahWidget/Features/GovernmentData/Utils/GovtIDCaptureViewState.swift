//
//  GovtIDCaptureViewState.swift
//
//
//  Created by Isaac Iniongun on 29/10/2023.
//

import Foundation

enum GovtIDCaptureViewState {
    case uploadFront, uploadBack
    case captureFront, captureBack
    case previewFront, previewBack
    
    var title: String {
        switch self {
        case .uploadFront:
            return "Upload the front of your ID"
        case .uploadBack:
            return "Upload the back of your ID"
        case .captureFront:
            return "Capture the front of your ID"
        case .captureBack:
            return "Capture the back of your ID"
        case .previewFront:
            return "Preview the front of your ID"
        case .previewBack:
            return "Preview the back of your ID"
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
        case .uploadFront, .uploadBack:
            return "Upload"
        case .captureFront, .captureBack:
            return "Capture"
        case .previewFront, .previewBack:
            return "Continue"
        }
    }
    
    var secondaryButtonTitle: String {
        switch self {
        case .uploadFront, .uploadBack:
            return "Capture Instead"
        case .captureFront, .captureBack:
            return "Upload instead"
        case .previewFront, .previewBack:
            return "Retake"
        }
    }
}
