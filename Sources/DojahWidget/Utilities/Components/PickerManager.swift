//
//  PickerManager.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation
import UIKit

class PickerManager: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var items: [String]!
    var selectedItem: ((Int) -> ())?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem?(row)
    }
}
