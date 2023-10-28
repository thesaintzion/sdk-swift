//
//  UILabel+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UILabel {
    convenience init(
        text: String,
        font: UIFont = .regular(15),
        numberOfLines: Int = 1,
        color: UIColor = .aLabel,
        alignment: NSTextAlignment = .left,
        adjustsFontSizeToFitWidth: Bool = true,
        underlined: Bool = false,
        huggingPriority: UILayoutPriority? = nil,
        huggingAxis: NSLayoutConstraint.Axis? = nil
    ) {
        self.init(frame: .zero)
        self.text = text
        self.textColor = color
        self.font = font
        self.numberOfLines = numberOfLines
        self.textAlignment = alignment
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        if underlined {
            underline()
        }
        if let huggingPriority = huggingPriority, let huggingAxis = huggingAxis {
            setContentHuggingPriority(huggingPriority, for: huggingAxis)
        }
    }
    
    convenience init(
        attributedText: NSAttributedString,
        numberOfLines: Int = 0,
        alignment: NSTextAlignment = .center
    ) {
        self.init(frame: .zero)
        self.attributedText = attributedText
        self.numberOfLines = numberOfLines
        self.textAlignment = alignment
        self.adjustsFontSizeToFitWidth = true
    }
    
    func setLineHeight(spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedText = attributedString
    }
    
    func cross() {
        let attr: NSMutableAttributedString =  NSMutableAttributedString(string: self.text ?? "")
        attr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attr.length))
        attributedText = attr
    }
    
    func underline() {
        let attr: NSMutableAttributedString =  NSMutableAttributedString(string: self.text ?? "")
        attr.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attr.length))
        attributedText = attr
        
    }
    
    func setText(_ text:String) {
        self.text = text
    }
}
