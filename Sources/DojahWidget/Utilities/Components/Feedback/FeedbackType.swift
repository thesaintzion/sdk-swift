//
//  FeedbackType.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation
import UIKit

enum FeedbackType {
    case success, failure, warning
    
    var icon: UIImage {
        switch self {
        case .success:
            return .res(.purpleSuccessCheckmark)
        case .failure:
            return .res(.xCircle)
        case .warning:
            return .res(.xCircle)
        }
    }
    
    var lottieAnimationName: String {
        switch self {
        case .success:
            return "success"
        case .failure:
            return "error-2"
        case .warning:
            return "warning"
        }
    }
}
