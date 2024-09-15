//
//  UIDatePicker+.swift
//
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

extension UIDatePicker {
    convenience init(dateMode: UIDatePicker.Mode) {
        self.init()
        if #available(iOS 14.0, *) {
            preferredDatePickerStyle = .inline
        } else {
            if #available(iOS 13.4, *) {
                preferredDatePickerStyle = .compact
            }
        }
        datePickerMode = dateMode
    }
    
    func dateString(format: String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}
