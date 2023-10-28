//
//  DJCountryPickerView.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class DJCountryPickerView: BaseView {

    private let titleLabel = UILabel(text: "Select a country", font: .primaryLight(13))
    private let flagImageView = UIImageView(image: .res(.ngFlag), height: 14, width: 19)
    private let valueLabel = UILabel(text: "Nigeria")
    private let arrowdownImageView = UIImageView(image: .res(.chevronDown), size: 10)
    private lazy var valueStackView = HStackView(
        subviews: [flagImageView, valueLabel, arrowdownImageView],
        spacing: 10,
        alignment: .center
    )
    lazy var valueView = UIView(
        subviews: [valueStackView],
        height: 50,
        backgroundColor: .primaryGrey,
        borderWidth: 1,
        borderColor: .djBorder,
        radius: 5
    )
    private lazy var contentStackView = VStackView(
        subviews: [titleLabel, valueView],
        spacing: 6
    )
    
    override func setup() {
        super.setup()
        clearBackground()
        
        with(contentStackView) {
            addSubview($0)
            $0.fillSuperview()
        }
        
        with(valueStackView) {
            $0.centerYInSuperview()
            $0.anchor(
                leading: valueView.leadingAnchor,
                trailing: valueView.trailingAnchor,
                padding: .kinit(leftRight: 15)
            )
        }
    }
    
    func updateInfo(country: Country) {
        with(country) {
            valueLabel.text = $0.name
            flagImageView.image = $0.flag
        }
    }

}
