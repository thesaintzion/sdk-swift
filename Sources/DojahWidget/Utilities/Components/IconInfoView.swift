//
//  FillFormView.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class IconInfoView: BaseView {

    private let iconLabel: IconUILabel
    
    init(
        text: String,
        textColor: UIColor = .djGreen,
        icon: UIImage = .res("greenInfoCircle"),
        bgColor: UIColor = .djLightGreen,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1,
        cornerRadius: CGFloat = 15
    ) {
        iconLabel = IconUILabel(
            text: text,
            icon: icon,
            position: .left,
            iconSize: 20,
            iconPadding: 2,
            textColor: textColor,
            alignment: textAlignment,
            numberOfLines: numberOfLines
        )
        
        super.init(frame: .zero)
        backgroundColor = bgColor
        viewCornerRadius = cornerRadius
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        with(iconLabel) {
            addSubview($0)
            $0.fillSuperview(padding: .kinit(topBottom: 6, leftRight: 8))
        }
    }

}
