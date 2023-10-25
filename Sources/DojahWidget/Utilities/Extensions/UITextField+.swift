//
//  UITextField+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UITextField {
    func restrictInputToDigits(
        string: String,
        allowCurrencyFormatting: Bool = false,
        currencySymbol: String = ""
    ) -> Bool {
        // remove non-numerics and compare with original string
        let currencyExtras = allowCurrencyFormatting ? ",\(currencySymbol)" : ""
        return string == string.filter("\(currencyExtras)0123456789".contains)
    }
    
    func restrictInputToDigits(
        range: NSRange,
        string: String,
        allowSpecialCharacterFormatting: Bool = false,
        specialCharacter: String = "",
        maxLength: Int? = nil
    ) -> Bool {
        
        if let maxLength = maxLength {
            // get the current text, or use an empty string if the failed
            let currentText = text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            //  make sure the result is under `maxLength` characters and remove non-numerics and compare with original string
            return string == string.filter("\(specialCharacter)0123456789".contains) && updatedText.count <= maxLength
        }
        
        return string == string.filter("\(specialCharacter)0123456789".contains)
    }
    
    func restrictToDigitsWithMaximumLength(range: NSRange, string: String, maxLength: Int) -> Bool {
        // get the current text, or use an empty string if the failed
        let currentText = text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        //  make sure the result is under `maxLength` characters and remove non-numerics and compare with original string
        return string == string.filter("0123456789".contains) && updatedText.count <= maxLength
        
    }
    
    func restrictToMaximumLength(range: NSRange, string: String, maxLength: Int) -> Bool {
        // get the current text, or use an empty string if the failed
        let currentText = text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        //  make sure the result is under `maxLength` characters and remove non-numerics and compare with original string
        return updatedText.count <= maxLength
        
    }
    
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil) {
        if let left = left {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: frame.size.height))
            leftViewMode = .always
        }
        if let right = right {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            rightViewMode = .always
        }
    }
}

func restrictTextfieldToDigitsWithMaximumLength(
    textField: UITextField,
    range: NSRange,
    string: String,
    maxLength: Int
) -> Bool {
    // get the current text, or use an empty string if the failed
    let currentText = textField.text ?? ""

    // attempt to read the range they are trying to change, or exit if we can't
    guard let stringRange = Range(range, in: currentText) else { return false }

    // add their new text to the existing text
    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    //  make sure the result is under `maxLength` characters and remove non-numerics and compare with original string
    return string == string.filter("0123456789".contains) && updatedText.count <= maxLength
    
}
