//
//  DatePickerViewDelegate.swift
//
//
//  Created by Isaac Iniongun on 21/11/2023.
//

import Foundation

protocol DatePickerViewDelegate: AnyObject {
    func didChooseDate(_ date: Date)
}
