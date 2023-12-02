//
//  HomeAddressViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class HomeAddressViewController: DJBaseViewController {
    
    private let homeAddressTextField = DJTextField(title: "Home address", placeholder: "Home address")
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.didTapContinueButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [homeAddressTextField, continueButton],
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
    }
    
    private func didTapContinueButton() {
        showFeedbackController(
            title: "Address Verification Success",
            message: "Your home address has been successfully verified, you will now be redirected"
        ) { [weak self] in
            self?.popToViewController(ofClass: DJDisclaimerViewController.self)
        }
    }

}
