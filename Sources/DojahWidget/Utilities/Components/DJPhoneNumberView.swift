//
//  DJPhoneNumberView.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class DJPhoneNumberView: BaseView {
    
    private let titleLabel = UILabel(text: "Enter phone number", font: .light(13))
    private let flagIconImageView = UIImageView(
        image: .res(.ngFlag),
        contentMode: .scaleAspectFill,
        height: 14,
        width: 19
    )
    private let codeLabel = UILabel(text: "+234", font: .regular(15)).withWidth(35)
    private let arrowdownImageView = UIImageView(image: .res(.chevronDown), size: 10)
    lazy var flagStackView = HStackView(
        subviews: [flagIconImageView, codeLabel, arrowdownImageView],
        spacing: 8,
        alignment: .center
    )
    private let lineView = UIView.separatorLine(color: .djBorder, height: 50, width: 1)
    private let textField = TextField()
    private lazy var textFieldStackView = HStackView(
        subviews: [flagStackView, lineView, textField],
        spacing: 15,
        alignment: .center
    )
    private lazy var contentView = UIView(
        subviews: [textFieldStackView],
        height: 50,
        backgroundColor: .primaryGrey,
        borderWidth: 1,
        borderColor: .djBorder,
        radius: 5
    )
    private lazy var contentStackView = VStackView(
        subviews: [titleLabel, contentView],
        spacing: 5
    )
    
    var fullNumber: String {
        "\(codeLabel.text.orEmpty)\(textField.text.orEmpty)"
    }

    override func setup() {
        super.setup()
        clearBackground()
        
        with(contentStackView) {
            addSubview($0)
            $0.fillSuperview()
        }
        
        with(textFieldStackView) {
            $0.fillSuperview(padding: .kinit(leftRight: 15))
            $0.setCustomSpacing(0, after: lineView)
        }
        
        with(textField) {
            $0.placeholder = "000-000-0000"
            $0.font = .regular(15)
        }
    }
    
    func updateInfo(country: Country) {
        with(country) {
            flagIconImageView.image = $0.flag
            codeLabel.text = $0.phoneCode
        }
    }

}
