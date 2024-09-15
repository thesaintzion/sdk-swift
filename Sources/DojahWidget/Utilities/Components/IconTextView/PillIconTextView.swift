//
//  PillIconTextView.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class PillIconTextView: BaseView {
    
    var iconTextView: IconTextView!
    
    var text: String? {
        get { iconTextView.text }
        set { iconTextView.text = newValue }
    }

    convenience init(
        text: String = "",
        font: UIFont = .regular(15),
        icon: UIImage? = nil,
        iconURL: String? = nil,
        iconTint: UIColor? = nil,
        iconTextAlignment: IconTextAlignment = .iconLeft,
        iconSize: CGFloat? = nil,
        iconHeight: CGFloat? = nil,
        iconWidth: CGFloat? = nil,
        textColor: UIColor = .aLabel,
        numberOfLines: Int = 0,
        textAlignment: NSTextAlignment = .center,
        contentDistribution: UIStackView.Distribution = .fill,
        contentAlignment: UIStackView.Alignment = .center,
        contentSpacing: CGFloat = 5,
        bgColor: UIColor = .djLightGreen,
        cornerRadius: CGFloat = 12
    ) {
        self.init(frame: .zero)
        iconTextView = IconTextView(
            text: text,
            font: font,
            icon: icon,
            iconURL: iconURL,
            iconTint: iconTint,
            iconTextAlignment: iconTextAlignment,
            iconSize: iconSize,
            iconHeight: iconHeight,
            iconWidth: iconWidth,
            textColor: textColor,
            numberOfLines: numberOfLines,
            textAlignment: textAlignment,
            contentDistribution: contentDistribution,
            contentAlignment: contentAlignment,
            contentSpacing: contentSpacing
        )
        
        with(iconTextView) {
            addSubview($0)
            $0.fillSuperview(padding: .kinit(topBottom: 8, leftRight: 12))
        }
        backgroundColor = bgColor
        viewCornerRadius = cornerRadius
    }

}
