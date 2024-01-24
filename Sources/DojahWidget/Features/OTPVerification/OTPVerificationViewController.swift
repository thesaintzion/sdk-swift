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
        spacing: 40
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        with(contentStackView) {
            addSubview($0)
            $0.anchor(
                top: navView.bottomAnchor,
                leading: safeAreaLeadingAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(topBottom: 50, leftRight: 20)
            )
        }
        
        phoneNumberView.showView(viewModel.isPhoneNumberVerification)
        emailTextField.showView(!viewModel.isPhoneNumberVerification)
    }
    
    private func didTapContinueButton() {
//        if viewModel.isPhoneNumberVerification {
//            viewModel.verificationInfo = phoneNumberView.fullNumber
//        } else {
//            viewModel.verificationInfo = emailTextField.text
//        }
//        kpush(VerifyOTPViewController(viewModel: viewModel))
    }

}
