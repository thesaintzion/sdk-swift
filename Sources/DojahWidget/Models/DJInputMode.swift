//
//  DJInputMode.swift
//
//
//  Created by Isaac Iniongun on 12/12/2023.
//

import Foundation
import UIKit

enum DJInputMode: String, Codable {
    case numeric = "numeric"
    case text = "text"
    case number = "number"
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .numeric, .number:
            return .numberPad
        case .text:
            return .alphabet
        }
    }
}
