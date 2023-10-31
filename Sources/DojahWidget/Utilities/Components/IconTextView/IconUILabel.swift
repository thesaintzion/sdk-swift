//
//  IconUILabel.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation

import UIKit

class IconUILabel: UILabel {

    convenience init(
        text: String,
        font: UIFont = .regular(15),
        icon: UIImage,
        position: IconPosition = .left,
        iconSize: Double = 18,
        iconPadding: Int = 3,
        textColor: UIColor = .aLabel,
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 1
    ) {
        self.init(frame: .zero)
        
        let textAttrs = NSMutableAttributedString()
        
        let imageAttachment = with(NSTextAttachment()) {
            $0.image = icon
            $0.bounds = CGRect(x: 0, y: -5, width: iconSize, height: iconSize)
        }
        
        var padding = ""
        (0..<iconPadding).forEach { _ in padding.append(" ") }
        
        let textAttributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: textColor
        ]
        
        switch position {
        case .left:
            with(textAttrs) {
                $0.append(imageAttachment.attributedString)
                $0.append(NSAttributedString(string: "\(padding)\(text)", attributes: textAttributes))
            }
        case .right:
            with(textAttrs) {
                $0.append(NSAttributedString(string: "\(text)\(padding)", attributes: textAttributes))
                $0.append(imageAttachment.attributedString)
            }
        }
        textAlignment = alignment
        attributedText = textAttrs
        self.numberOfLines = numberOfLines
    }

}

extension NSTextAttachment {
    var attributedString: NSAttributedString {
        NSAttributedString(attachment: self)
    }
}
