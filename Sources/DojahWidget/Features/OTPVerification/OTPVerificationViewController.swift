//
//  OTPVerificationViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class OTPVerificationViewController: DJBaseViewController {
    
    private let viewModel: OTPVerificationViewModel
    
    init(viewModel: OTPVerificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let phoneNumberView = DJPhoneNumberView()
    private let emailTextField = DJTextField(title: "Email address", placeholder: "Email address")
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.didTapContinueButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [phoneNumberView, emailTextField, continueButton],
        spacing: 20
    )
    private lazy var contentScrollView = UIScrollView(children: [contentStackView])

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
            
            contentStackView.anchor(
                top: $0.ktopAnchor,
                leading: $0.kleadingAnchor,
                bottom: $0.kbottomAnchor,
                trailing: $0.ktrailingAnchor,
                padding: .kinit(top: 50, bottom: 20)
            )
        }
        
        phoneNumberView.showView(viewModel.isPhoneNumberVerification)
        emailTextField.showView(!viewModel.isPhoneNumberVerification)
    }
    
    override func addTapGestures() {
        super.addTapGestures()
        phoneNumberView.flagStackView.didTap { [weak self] in
            self?.showCountries()
        }
    }
    
    private func showCountries() {
        showSelectableItemsViewController(
            title: "Choose Country",
            items: Country.allCases,
            height: 220,
            delegate: self
        )
    }
    
    private func didTapContinueButton() {
        if viewModel.isPhoneNumberVerification {
            viewModel.verificationInfo = phoneNumberView.fullNumber
        } else {
            viewModel.verificationInfo = emailTextField.text
        }
        kpushViewController(VerifyOTPViewController(viewModel: viewModel))
    }

}

extension OTPVerificationViewController: SelectableItemsViewDelegate {
    func didChooseItem(_ item: SelectableItem) {
        if let country = item as? Country {
            phoneNumberView.updateInfo(country: country)
        }
    }
}
