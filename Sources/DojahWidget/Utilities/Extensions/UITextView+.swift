//
//  UITextView+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UITextView {
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
}
