//
//  GovernmentDataViewController.swift
//
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class GovernmentDataViewController: DJBaseViewController {

    private let fillFormView = IconInfoView(text: "Fill the form as it appears on your valid ID")
    private lazy var govtIDView = DJPickerView(
        title: "Government Identification",
        items: GovtID.allCases.titles,
        itemSelectionHandler: didChooseGovtID
    )
    private let govtIDNumberTextField = DJTextField(title: "Govt. ID Number")
    private lazy var verificationMethodView = DJPickerView(
        title: "Verify with",
        items: GovtIDVerificationMethod.allCases.titles,
        itemSelectionHandler: didChooseGovtVerificationMethod
    )
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.didTapContinueButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [govtIDView, govtIDNumberTextField, verificationMethodView, continueButton],
        spacing: 20
    )
    private lazy var contentScrollView = UIScrollView(children: [fillFormView, contentStackView])
    private var govtID: GovtID?
    private var govtIDVerificationMethod: GovtIDVerificationMethod?
    
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
            contentStackView.setCustomSpacing(40, after: verificationMethodView)
        }
        
        govtIDNumberTextField.showView(false)
    }
    
    private func didTapContinueButton() {
        guard let govtIDVerificationMethod else { return }
        switch govtIDVerificationMethod {
        case .govtID:
            kpush(GovtIDCaptureViewController(verificationMethod: govtIDVerificationMethod))
        case .selfie, .videoKYC:
            let viewModel = SelfieVideoKYCViewModel(verificationMethod: govtIDVerificationMethod)
            kpush(SelfieVideoKYCViewController(viewModel: viewModel))
        case .phoneNumberOTP, .emailOTP:
            let viewModel = OTPVerificationViewModel(verificationMethod: govtIDVerificationMethod)
            kpush(OTPVerificationViewController(viewModel: viewModel))
        }
    }
    
    private func didChooseGovtID(name: String, index: Int) {
        guard let govtId = GovtID(rawValue: index) else { return }
        govtID = govtId
        govtIDView.updateValue(govtId.title)
        with(govtIDNumberTextField) {
            $0.textField.placeholder = govtId.numberTitle
            $0.title = govtId.numberTitle
            $0.showView()
        }
    }
    
    private func didChooseGovtVerificationMethod(name: String, index: Int) {
        guard let method = GovtIDVerificationMethod(rawValue: index) else { return }
        govtIDVerificationMethod = method
        verificationMethodView.updateValue(method.title)
    }

}
