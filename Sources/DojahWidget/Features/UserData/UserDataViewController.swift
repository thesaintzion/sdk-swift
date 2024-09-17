//
//  BioDataViewController.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class UserDataViewController: DJBaseViewController {
    
    private let viewModel: UserDataViewModel
    
    init(viewModel: UserDataViewModel = UserDataViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        kviewModel = viewModel
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        placeholder: DJConstants.dateFormat,
        validationType: .dob,
        editable: false,
        rightIcon: .res("calendar")
    )
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.didTapContinueButton()
    }
    private lazy var termsView = TermsAndPrivacyView(delegate: self)
    private lazy var contentStackView = VStackView(
        subviews: [firstNameTextField, lastNameTextField, middleNameTextField, dobTextField, continueButton, termsView],
        spacing: 20
    )
    private lazy var contentScrollView = UIScrollView(children: [contentStackView])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        viewModel.viewProtocol = self
        with(contentScrollView) {
            addSubview($0)
            
            $0.anchor(
                top: navView.bottomAnchor,
                leading: safeAreaLeadingAnchor,
                bottom: poweredView.topAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(leftRight: 20)
            )
            
            contentStackView.anchor(
                top: $0.ktopAnchor,
                leading: $0.kleadingAnchor,
                bottom: $0.kbottomAnchor,
                trailing: $0.ktrailingAnchor,
                padding: .kinit(top: 50, bottom: 20)
            )
        }
        
        navView.showSuccessMessage("Fill the form as it appears on your valid ID")
    }
    
    private func didTapContinueButton() {
        if [firstNameTextField, middleNameTextField, lastNameTextField, dobTextField].areValid {
            viewModel.saveUserData(
                firstName: firstNameTextField.text,
                middleName: middleNameTextField.text,
                lastName: lastNameTextField.text,
                dob: dobTextField.text
            )
        }
    }
    
    override func addTapGestures() {
        dobTextField.textField.didTap(duration: 0.05) { [weak self] in
            self?.didTapDOBTextField()
        }
    }
    
    private func didTapDOBTextField() {
        view.endEditing(true)
        let datePickerController = DatePickerController()
        datePickerController.delegate = self
        present(datePickerController, animated: true)
    }

}

extension UserDataViewController: UserDataViewProtocol {
    func showErrorMessage(_ message: String) {
        navView.showErrorMessage(message)
    }
    
    func hideMessage() {
        navView.showSuccessMessage("Fill the form as it appears on your valid ID")
    }
}

extension UserDataViewController: TermsAndPrivacyViewDelegate {
    func didTapTerms() {}
    
    func didTapPrivacy() {}
}

extension UserDataViewController: DatePickerViewDelegate {
    func didChooseDate(_ date: Date) {
        dobTextField.text = date.string(format: DJConstants.dateFormat)
    }
}
