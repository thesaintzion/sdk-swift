//
//  BioDataViewController.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class BioDataViewController: DJBaseViewController {

    private let fillFormLabel = IconUILabel(
        text: "Fill the form as it appears on your valid ID",
        icon: .res(.greenInfoCircle),
        position: .left,
        iconSize: 20,
        iconPadding: 2,
        textColor: .djGreen
    )
    private lazy var fillFormView = UIView(
        subviews: [fillFormLabel],
        backgroundColor: .djLightGreen,
        radius: 15
    )
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
        placeholder: "dd/mm/yyyy"
    )
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.showGovtID()
    }
    private lazy var termsView = TermsAndPrivacyView(delegate: self)
    private lazy var contentStackView = VStackView(
        subviews: [firstNameTextField, lastNameTextField, middleNameTextField, dobTextField, continueButton, termsView],
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
                padding: .kinit(top: 30)
            )
            fillFormLabel.fillSuperview(padding: .kinit(topBottom: 6, leftRight: 8))
            
            contentStackView.anchor(
                top: fillFormView.bottomAnchor, 
                leading: $0.kleadingAnchor,
                bottom: $0.kbottomAnchor,
                trailing: $0.ktrailingAnchor,
                padding: .kinit(top: 40, bottom: 20)
            )
            
        }
    }
    
    private func showGovtID() {
        
    }

}

extension BioDataViewController: TermsAndPrivacyViewDelegate {
    func didTapTerms() {
        
    }
    
    func didTapPrivacy() {
        
    }
}
