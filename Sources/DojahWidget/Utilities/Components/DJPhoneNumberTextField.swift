//
//  DJPhoneNumberTextField.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class DJPhoneNumberTextField: BaseView {
    
    private let titleLabel = UILabel(text: "Enter phone number", font: .light(13))
    private let flagIconImageView = UIImageView(
        image: .res("ngFlag"),
        contentMode: .scaleAspectFill,
        height: 14,
        width: 19
    )
    private let codeLabel = UILabel(text: "+234", font: .regular(15)).withWidth(35)
    private let arrowdownImageView = UIImageView(image: .res("chevronDown"), size: 10)
    private lazy var flagStackView = HStackView(
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
    var didChooseCountry: ParamHandler<Int>?
    var textDidChange: ParamHandler<String>? = nil
    private lazy var dropdownView: DropDown = {
        with(DropDown()) {
            $0.textFont = .regular(15)
            $0.direction = .bottom
            $0.selectionAction = { [weak self] index, _ in
                self?.didChooseCountry?(index)
            }
        }
    }()
    
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
            $0.font = .regular(15)
            $0.keyboardType = .numberPad
            $0.attributedPlaceholder = NSAttributedString(
                string: "000-000-0000",
                attributes: [
                    .font: UIFont.regular(14),
                    .foregroundColor: UIColor.aPlaceholderText
                ]
            )
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        flagStackView.didTap { [weak self] in
            self?.showCountries()
        }
    }
    
    private func showCountries() {
        with(dropdownView) {
            $0.anchorView = contentView
            $0.kwidth = 112
            $0.bottomOffset = CGPoint(x: 0, y:($0.anchorView?.plainView.bounds.height)!)
            $0.show()
        }
    }
    
    func updateDatasource(_ datasource: [String]) {
        dropdownView.dataSource = datasource
    }
    
    func updateCountryDetails(phoneCode: String, flag: UIImage) {
        flagIconImageView.image = flag
        codeLabel.text = phoneCode
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textDidChange?(textField.text.orEmpty)
    }

}

extension DJPhoneNumberTextField: UITextFieldDelegate {
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        textField.restrictInputToDigits(string: string)
    }
}
