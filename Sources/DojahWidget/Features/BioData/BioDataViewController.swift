//
//  BioDataViewController.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class BioDataViewController: DJBaseViewController {

    private let fillFormView = FillFormView()
    private let firstNameTextField = DJTextField(
        title: "First name",
        placeholder: "First name",
        validationType: .name
    )
    private let lastNameTextField = DJTextField(
        title: "Last name",
        placeholder: "Last name",
        validationType: .name
    )
    private let middleNameTextField = DJTextField(
        title: "Middle name",
        placeholder: "Middle name",
        validationType: .name
    )
    private let dobTextField = DJTextField(
        title: "Date of birth",
        placeholder: "dd/mm/yyyy",
        editable: false,
        rightIcon: .res(.calendar)
    )
    private let datePicker = UIDatePicker(dateMode: .date)
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.showGovtID()
    }
    private lazy var termsView = TermsAndPrivacyView(delegate: self)
    private lazy var contentStackView = VStackView(
        subviews: [firstNameTextField, lastNameTextField, middleNameTextField, dobTextField, datePicker, continueButton, termsView],
        spacing: 20
    )
    private lazy var contentScrollView = UIScrollView(children: [fillFormView, contentStackView])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        with(contentScrollView) {
            addSubview($0)
            
            $0.anchor(
                top: navView.bottomAnchor,
                leading: safeAreaLeadingAnchor,
                bottom: poweredView.topAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(leftRight: 20)
            )
            
            fillFormView.centerXInSuperview()
            fillFormView.anchor(
                top: $0.ktopAnchor,
                padding: .kinit(top: 40)
            )
            
            contentStackView.anchor(
                top: fillFormView.bottomAnchor, 
                leading: $0.kleadingAnchor,
                bottom: $0.kbottomAnchor,
                trailing: $0.ktrailingAnchor,
                padding: .kinit(top: 50, bottom: 20)
            )
        }
        contentStackView.setCustomSpacing(4, after: dobTextField)
        with(datePicker) {
            $0.showView(false)
            $0.addTarget(self, action: #selector(dateDidChanged), for: .valueChanged)
            $0.maximumDate = Date()
        }
    }
    
    private func showGovtID() {
        
    }
    
    override func addTapGestures() {
        dobTextField.textField.didTap { [weak self] in
            self?.didTapDOBTextField()
        }
    }
    
    private func didTapDOBTextField() {
        datePicker.isHidden.toggle()
    }
    
    @objc private func dateDidChanged() {
        dobTextField.text = datePicker.dateString()
    }

}

extension BioDataViewController: TermsAndPrivacyViewDelegate {
    func didTapTerms() {
        
    }
    
    func didTapPrivacy() {
        
    }
}
