//
//  DJTextField.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

final class DJTextField: BaseView {
    private let titleLabel = UILabel(
        text: "Title Label",
        font: .regular(13),
        numberOfLines: 0,
        color: .aLabel,
        alignment: .left
    )
    private let errorLabel = UILabel(
        text: "Error Label",
        font: .regular(13),
        numberOfLines: 0, 
        color: .systemRed,
        alignment: .left
    )
    let textField = TextField()
    lazy var valueView = UIView(
        subviews: [textField],
        height: 50,
        backgroundColor: .primaryGrey,
        borderWidth: 1,
        borderColor: .djBorder,
        radius: 5
    )
    let leftIconImageView = UIImageView()
    private let rightIconImageView = UIImageView(image: UIImage(), tintColor: .primary, size: 22)
    private let pickerManager = PickerManager()
    private let pickerView = UIPickerView()
    private var passwordVisible = false
    private var validationType: ValidationType?
    private let inputValidator = InputValidatorImpl()
    private var heightConstraint: NSLayoutConstraint?
    private var errorLabelHeightConstraint: NSLayoutConstraint?
    private var errorLabelVisible = false
    var maxLength: Int? = nil
    var textDidChange: ParamHandler<String>? = nil
    
    var title: String {
        get { titleLabel.text.orEmpty }
        set { titleLabel.text = newValue }
    }
    
    var text: String {
        get { textField.text.orEmpty }
        set { textField.text = newValue }
    }
    
    convenience init(
        title: String,
        placeholder: String = "",
        isPassword: Bool = false,
        height: CGFloat? = 80,
        validationType: ValidationType? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        maxLength: Int? = nil,
        editable: Bool = true,
        rightIcon: UIImage? = nil
    ) {
        self.init(frame: .zero)
        backgroundColor = .clear
        titleLabel.text = title
        with(textField) {
            $0.keyboardType = keyboardType
            $0.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .font: UIFont.regular(14),
                    .foregroundColor: UIColor.aPlaceholderText
                ]
            )
            $0.font = .regular(15)
            $0.autocapitalizationType = .none
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            $0.enableUserInteraction(editable)
        }
        titleLabel.constraintHeight(titleLabel.intrinsicContentSize.height)
        self.validationType = validationType
        self.maxLength = maxLength
        if let height = height {
            heightConstraint = constraintHeight(height)
        }
        
        if isPassword {
            setupPassword()
        }
        
        if let rightIcon {
            addRightIcon(rightIcon)
        }
    }
    
    convenience init(
        title: String,
        valueText: String? = nil,
        placeholder: String = "Select",
        height: CGFloat? = 80,
        items: [String],
        validationType: ValidationType? = nil,
        maxLength: Int? = nil,
        leftIconConfig: IconConfig? = nil,
        itemSelectionHandler: IntStringParamHandler? = nil
    ) {
        self.init(frame: .zero)
        backgroundColor = .clear
        titleLabel.text = title
        self.validationType = validationType
        self.maxLength = maxLength
        with(textField) {
            $0.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .font: UIFont.regular(14),
                        .foregroundColor: UIColor.aPlaceholderText
                ]
            )
            $0.font = .regular(15)
            $0.text = valueText
        }
        titleLabel.constraintHeight(titleLabel.intrinsicContentSize.height)
        if let height = height {
            heightConstraint = constraintHeight(height)
        }
        
        pickerManager.items = items
        pickerManager.selectedItem = { [weak self] index in
            self?.textField.text = items[index]
            self?.textField.resignFirstResponder()
            itemSelectionHandler?(index, items[index])
        }
        pickerView.delegate = pickerManager
        pickerView.dataSource = pickerManager
        textField.inputView = pickerView
        addDropDownChevron()
        if let leftIconConfig {
            addLeftIcon(iconConfig: leftIconConfig)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        hideError()
        textDidChange?(textField.text.orEmpty)
        switch validationType {
        case .amount:
            textField.text = textField.text?.amountSanitized.double?.currencyFormatted()
        default:
            break
        }
    }
    
    func setupPassword() {
        let paddingView = UIView(size: 15, backgroundColor: .clear)
        let passwordIconStackView = HStackView(subviews: [rightIconImageView, paddingView], alignment: .center)
        with(textField) {
            $0.padding = .kinit(top: 0, left: 15, bottom: 0, right: 45)
            $0.rightView = passwordIconStackView
            $0.rightViewMode = .always
            $0.isSecureTextEntry = true
            $0.setNeedsLayout()
            $0.layoutIfNeeded()
        }
        rightIconImageView.didTap(duration: 0.1, completion: togglePasswordVisibility)
    }
    
    func togglePasswordVisibility() {
        if !passwordVisible && text.isNotEmpty {
            textField.isSecureTextEntry = false
            passwordVisible = true
            rightIconImageView.image = UIImage()
        } else {
            textField.isSecureTextEntry = true
            passwordVisible = false
            rightIconImageView.image = UIImage()
        }
    }
    
    override public func setup() {
        super.setup()
        addSubviews(titleLabel, textField, errorLabel)
        
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor
        )
        
        with(textField) {
            $0.anchor(
                top: titleLabel.bottomAnchor,
                leading: leadingAnchor,
                trailing: trailingAnchor,
                padding: .kinit(top: 5)
            )
            $0.constraintHeight(50)
            $0.viewCornerRadius = 5
            $0.viewBorderWidth = 0.7
            $0.borderColor = .djBorder
            $0.backgroundColor = .primaryGrey
            $0.clipsToBounds = true
        }
        
        with(errorLabel) {
            $0.anchor(
                top: textField.bottomAnchor,
                leading: leadingAnchor,
                trailing: trailingAnchor,
                padding: .kinit(top: 4)
            )
            $0.showView(false)
        }
    }
    
    fileprivate func addDropDownChevron() {
        let dropButton = UIButton(type: .system)
        dropButton.frame = CGRect(x: 0, y: 5, width: frame.height, height: frame.height)
        dropButton.setImage(.res("chevronDown"), for: .normal)
        dropButton.tintColor = .aLabel
        dropButton.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        dropButton.addTarget(self, action: #selector(dropdownButtonSelected), for: .touchUpInside)
        textField.rightView =  HStackView(subviews: [dropButton, UIView.hspacer(5)], alignment: .center)
        textField.rightViewMode = .always
    }
    
    private func addRightIcon(_ icon: UIImage) {
        let iconButton = UIButton(type: .system)
        iconButton.frame = CGRect(x: 0, y: 5, width: frame.height, height: frame.height)
        iconButton.setImage(icon, for: .normal)
        iconButton.tintColor = .aSecondaryLabel
        iconButton.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        textField.rightView =  HStackView(subviews: [iconButton, UIView.hspacer(5)], alignment: .center)
        textField.rightViewMode = .always
    }
    
    private func addLeftIcon(iconConfig: IconConfig) {
        with(leftIconImageView) {
            $0.image = iconConfig.icon
            $0.constraintSize(iconConfig.size)
            $0.contentMode = iconConfig.contentMode
        }
        textField.leftView =  HStackView(
            subviews: [UIView.hspacer(10), leftIconImageView, UIView.hspacer(10)],
            alignment: .center
        )
        textField.padding = .kinit(left: 35, right: 15)
        textField.leftViewMode = .always
    }
    
    @objc fileprivate func dropdownButtonSelected() {
        textField.becomeFirstResponder()
    }
    
    func localizeUI(title: String) {
        titleLabel.text = title
    }
    
    var isValid: Bool {
        if let validationType = validationType {
            let result = inputValidator.validate(text, for: validationType)
            result.isValid ? hideError() : showError(result.message)
            return result.isValid
        }
        return false
    }
    
    func isValidPasswordConfirmation(password: String) -> Bool {
        let result = inputValidator.validateConfirmPassword(password, text)
        result.isValid ? hideError() : showError(result.message)
        return result.isValid
    }
    
    func showError(_ message: String) {
        with(errorLabel) {
            $0.text = message
            if !errorLabelVisible {
                errorLabelVisible = true
                errorLabelHeightConstraint = $0.constraintHeight(errorLabel.intrinsicContentSize.height)
                heightConstraint?.constant += errorLabelHeightConstraint!.constant
                kanimate(duration: 0.2) { [weak self] in
                    self?.errorLabel.showView()
                    self?.updateTextFieldAppearance(success: false)
                    self?.layoutIfNeeded()
                }
            }
        }
        
    }
    
    func hideError() {
        if errorLabelVisible {
            errorLabelVisible = false
            heightConstraint?.constant -= (errorLabelHeightConstraint?.constant ?? 0)
            if let errorLabelHeightConstraint {
                removeConstraint(errorLabelHeightConstraint)
            }
            errorLabelHeightConstraint = nil
        }
        kanimate(duration: 0.2) { [weak self] in
            self?.errorLabel.showView(false)
            self?.updateTextFieldAppearance()
            self?.layoutIfNeeded()
        }
    }
    
    fileprivate func updateTextFieldAppearance(success: Bool = true) {
        with(textField) {
            $0.borderColor = success ? .djBorder : .systemRed
            if !success {
                $0.shake(duration: 0.2)
            }
        }
    }
    
}

extension DJTextField: UITextFieldDelegate {
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        switch textField.keyboardType {
        case .decimalPad:
            return textField.restrictInputToDigits(
                range: range,
                string: string,
                allowSpecialCharacterFormatting: true,
                specialCharacter: ".",
                maxLength: maxLength
            )
        default:
            return restrictTextfield(range, string)
        }
    }
    
    fileprivate func restrictTextfield(_ range: NSRange, _ string: String) -> Bool {
        if let maxLength = maxLength {
            if [.numberPad, .phonePad].contains(textField.keyboardType) {
                return textField.restrictToDigitsWithMaximumLength(range: range, string: string, maxLength: maxLength)
            } else {
                return textField.restrictToMaximumLength(range: range, string: string, maxLength: maxLength)
            }
        } else {
            if [.numberPad, .phonePad].contains(textField.keyboardType) {
                return textField.restrictInputToDigits(string: string)
            }
            return true
        }
    }
    
}

class TextField: UITextField {
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) {
        didSet {
            setNeedsLayout()
        }
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}

extension Array where Element == DJTextField {
    var areValid: Bool {
        let isValid = map { $0.isValid }.doesNotContain(false)
        if !isValid {
            first?.textField.becomeFirstResponder()
            generateHapticFeedback()
        }
        return isValid
    }
}
