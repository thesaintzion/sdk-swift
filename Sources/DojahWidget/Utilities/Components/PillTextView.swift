//
//  PillTextView.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class PillTextView: BaseView {

    let textLabel: UILabel
    
    var text: String {
        get { textLabel.text.orEmpty }
        set { textLabel.text = newValue }
    }
    
    init(
        text: String,
        textColor: UIColor,
        bgColor: UIColor,
        radius: CGFloat = 15
    ) {
        textLabel = UILabel(
            text: text,
            font: .regular(14),
            numberOfLines: 0,
            color: textColor,
            alignment: .center
        )
        super.init(frame: .zero)
        backgroundColor = bgColor
        viewCornerRadius = radius
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        with(textLabel) {
            addSubview($0)
            $0.fillSuperview(padding: .kinit(topBottom: 8, leftRight: 12))
        }
    }

}
