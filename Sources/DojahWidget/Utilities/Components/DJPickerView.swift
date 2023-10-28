//
//  DJPickerView.swift
//
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class DJPickerView: BaseView {

    private let titleLabel = UILabel(text: "", font: .light(13))
    private let leftIconImageView = UIImageView()
    private let valueLabel = UILabel(text: "")
    private let arrowdownImageView = UIImageView(image: .res(.chevronDown), size: 10)
    private lazy var valueStackView = HStackView(
        subviews: [leftIconImageView, valueLabel, arrowdownImageView],
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
    
    init(
        title: String,
        value: String = "",
        leftIconConfig: IconConfig = .init()
    ) {
        super.init(frame: .zero)
        titleLabel.text = title
        updateValue(value)
        updateLeftIcon(config: leftIconConfig)
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func updateLeftIcon(config: IconConfig) {
        with(leftIconImageView) {
            $0.image = config.icon
            $0.contentMode = config.contentMode
            $0.constraintSize(config.size)
        }
    }
    
    func updateInfo(country: Country) {
        with(country) {
            valueLabel.text = $0.name
            leftIconImageView.image = $0.flag
        }
    }
    
    func updateValue(_ value: String) {
        with(valueLabel) {
            $0.text = value.isEmpty ? "Choose" : value
            $0.textColor = value.isEmpty ? .aSecondaryLabel : .aLabel
        }
    }

}
