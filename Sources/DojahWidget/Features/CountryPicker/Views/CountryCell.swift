//
//  CountryCell.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class CountryCell: BaseTableViewCell {

    private let flagImageView = UIImageView(image: .res(.ngFlag), height: 14, width: 19)
    private let nameLabel = UILabel(text: "")
    private lazy var contentStackView = HStackView(
        subviews: [flagImageView, nameLabel],
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
    
    func configure(country: Country) {
        with(country) {
            flagImageView.image = $0.flag
            nameLabel.text = $0.name
        }
    }

}
