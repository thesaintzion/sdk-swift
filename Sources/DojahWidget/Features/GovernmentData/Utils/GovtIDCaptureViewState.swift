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
    case captureCACDocument, uploadCACDocument, previewCACDocument
    case captureDocument, uploadDocument, previewDocument
    
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
        case .captureCACDocument:
            return "Capture CAC Document"
        case .uploadCACDocument:
            return "Upload CAC Document"
        case .previewCACDocument:
            return "Preview CAC Document"
        case .captureDocument:
            return "Capture Document"
        case .uploadDocument:
            return "Upload Document"
        case .previewDocument:
            return "Preview Document"
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
        case .uploadFront, .uploadBack, .uploadCACDocument, .uploadDocument:
            return "Upload"
        case .captureFront, .captureBack, .captureCACDocument, .captureDocument:
            return "Capture"
        case .previewFront, .previewBack, .previewCACDocument, .previewDocument:
            return "Continue"
        }
    }
    
    var secondaryButtonTitle: String {
        switch self {
        case .uploadFront, .uploadBack, .uploadCACDocument, .uploadDocument:
            return "Capture Instead"
        case .captureFront, .captureBack, .captureCACDocument, .captureDocument:
            return "Upload Instead"
        case .previewFront, .previewBack, .previewCACDocument, .previewDocument:
            return "Retake"
        }
    }
}
