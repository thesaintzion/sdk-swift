//
//  DisclaimerCell.swift
//  
//
//  Created by Isaac Iniongun on 27/10/2023.
//

import UIKit

final class DisclaimerCell: BaseTableViewCell {

    private let checkImageView = UIImageView(
        image: .res("purpleSuccessTickIcon").withRenderingMode(.alwaysTemplate),
        tintColor: .primary,
        size: 14
    )
    let infoLabel = UILabel(
        text: "", 
        numberOfLines: 0,
        alignment: .left
    )
    private lazy var contentStackView = HStackView(
        subviews: [checkImageView, infoLabel],
        spacing: 10,
        alignment: .center
    )
    
    override func setup() {
        clearBackground()
        with(contentStackView) {
            kaddSubview($0)
            $0.fillSuperview(padding: .kinit(topBottom: 10))
        }
    }

}
