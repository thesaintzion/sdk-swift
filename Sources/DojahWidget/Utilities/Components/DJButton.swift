//
//  DJButton.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

class DJButton: UIButton {
    
    var tapAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(
        title: String? = nil,
        attributedTitle: NSAttributedString? = nil,
        font: UIFont = .semibold(15),
        backgroundColor: UIColor = .primary,
        textColor: UIColor = .white,
        borderWidth: CGFloat? = nil,
        borderColor: UIColor? = nil,
        cornerRadius: CGFloat = 8,
        height: CGFloat? = 50,
        width: CGFloat? = nil,
        size: CGFloat? = nil,
        image: UIImage? = nil,
        tintColor: UIColor? = nil,
        isEnabled: Bool = true,
        tapAction: (() -> Void)? = nil
    ) {
        self.init(type: .system)
        self.backgroundColor = backgroundColor
        viewCornerRadius = cornerRadius
        self.title = title
        self.textColor = textColor
        clipsToBounds = true
        self.font = font
        enable(isEnabled)
        if let attributedTitle = attributedTitle {
            self.attributedTitle = attributedTitle
        }
        
        if let image = image {
            setImage(image, for: .normal)
        }
        
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        
        if let borderColor = borderColor {
            self.borderColor = borderColor
        }
        
        if let borderWidth = borderWidth {
            viewBorderWidth = borderWidth
        }
        
        if let height = height {
            constraintHeight(height)
        }
        
        if let width = width {
            constraintWidth(width)
        }
        
        if let size = size {
            constraintSize(size)
        }
        
        self.tapAction = tapAction
        
        addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
    }
    
    @objc fileprivate func handleButtonTap() {
        tapAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
