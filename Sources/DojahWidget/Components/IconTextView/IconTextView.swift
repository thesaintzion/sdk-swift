//
//  IconTextView.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

enum IconTextAlignment {
    case iconRight, iconLeft, iconTop, iconBottom
}

class IconTextView: BaseView {
    
    fileprivate let textLabel = UILabel()
    let iconImageView = UIImageView()

    convenience init(
        text: String = "",
        font: UIFont = .primaryRegular(15),
        placeholderIcon: UIImage? = nil,
        iconURL: String? = nil,
        iconTint: UIColor? = nil,
        iconTextAlignment: IconTextAlignment = .iconLeft,
        iconSize: CGFloat? = nil,
        iconHeight: CGFloat? = nil,
        iconWidth: CGFloat? = nil,
        textColor: UIColor = .aLabel,
        numberOfLines: Int = 0,
        textAlignment: NSTextAlignment = .left,
        contentStackDistribution: UIStackView.Distribution = .fill,
        contentStackAlignment: UIStackView.Alignment = .fill,
        contentSpacing: CGFloat = 8
    ) {
        self.init(frame: .zero)
        
        with(textLabel) {
            $0.text = text
            $0.font = font
            $0.numberOfLines = numberOfLines
            $0.textColor = textColor
            $0.textAlignment = textAlignment
        }
        
        with(iconImageView) {
            if let iconSize = iconSize {
                $0.constraintSize(iconSize)
            }
            if let iconHeight = iconHeight {
                $0.constraintHeight(iconHeight)
            }
            if let iconWidth = iconWidth {
                $0.constraintWidth(iconWidth)
            }
            $0.image = placeholderIcon
            $0.contentMode = .scaleAspectFit
            if let iconTint = iconTint {
                $0.tintColor = iconTint
            }
        }
        
        var contentStackView: UIStackView
        
        switch iconTextAlignment {
        case .iconRight:
            contentStackView = HStackView(
                subviews: [textLabel, iconImageView],
                spacing: contentSpacing,
                distribution: contentStackDistribution,
                alignment: contentStackAlignment
            )
        case .iconLeft:
            contentStackView = HStackView(
                subviews: [iconImageView, textLabel],
                spacing: contentSpacing,
                distribution: contentStackDistribution,
                alignment: contentStackAlignment
            )
        case .iconTop:
            contentStackView = VStackView(
                subviews: [iconImageView, textLabel],
                spacing: contentSpacing,
                distribution: contentStackDistribution,
                alignment: contentStackAlignment
            )
        case .iconBottom:
            contentStackView = VStackView(
                subviews: [textLabel, iconImageView],
                spacing: contentSpacing,
                distribution: contentStackDistribution,
                alignment: contentStackAlignment
            )
        }
        
        addSubview(contentStackView)
        contentStackView.fillSuperview()
        
        if let iconURL = iconURL {
            iconImageView.setImageFromURL(url: iconURL, placeholderImage: placeholderIcon)
        }
    }
    
    convenience init(
        attributedText: NSAttributedString,
        placeholderIcon: UIImage? = nil,
        iconURL: String? = nil,
        iconTextAlignment: IconTextAlignment = .iconLeft,
        iconSize: CGFloat = 18,
        numberOfLines: Int = 0,
        textAlignment: NSTextAlignment = .left,
        contentStackDistribution: UIStackView.Distribution = .fill,
        contentStackAlignment: UIStackView.Alignment = .fill,
        contentSpacing: CGFloat = 8
    ) {
        self.init(frame: .zero)
        
        with(textLabel) {
            $0.attributedText = attributedText
            $0.numberOfLines = numberOfLines
            $0.textAlignment = textAlignment
        }
        
        with(iconImageView) {
            $0.constraintSize(iconSize)
            $0.image = placeholderIcon
        }
        
        var contentStackView: UIStackView
        
        switch iconTextAlignment {
        case .iconRight:
            contentStackView = HStackView(
                subviews: [textLabel, iconImageView],
                spacing: contentSpacing,
                distribution: contentStackDistribution,
                alignment: contentStackAlignment
            )
        case .iconLeft:
            contentStackView = HStackView(
                subviews: [iconImageView, textLabel],
                spacing: contentSpacing,
                distribution: contentStackDistribution,
                alignment: contentStackAlignment
            )
        case .iconTop:
            contentStackView = VStackView(
                subviews: [iconImageView, textLabel],
                spacing: contentSpacing,
                distribution: contentStackDistribution,
                alignment: contentStackAlignment
            )
        case .iconBottom:
            contentStackView = VStackView(
                subviews: [textLabel, iconImageView],
                spacing: contentSpacing,
                distribution: contentStackDistribution,
                alignment: contentStackAlignment
            )
        }
        
        addSubview(contentStackView)
        contentStackView.fillSuperview()
        
        if let iconURL = iconURL {
            iconImageView.setImageFromURL(url: iconURL, placeholderImage: placeholderIcon)
        }
    }
    
    var text: String? {
        get { textLabel.text }
        set { textLabel.text = newValue }
    }
    
    var textColor: UIColor? {
        get { textLabel.textColor }
        set { textLabel.textColor = newValue }
    }
    
    var iconImageURL: String? {
        didSet {
            if let iconImageURL {
                iconImageView.setImageFromURL(url: iconImageURL, placeholderImage: iconImageView.image)
            }
        }
    }
    
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
    
    var icontTint: UIColor? {
        get { iconImageView.tintColor }
        set { iconImageView.tintColor = newValue }
    }

}
