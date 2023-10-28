//
//  CountryPickerViewController.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class CountryPickerViewController: DJBaseViewController {

    private let countryPickerView = DJCountryPickerView()
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.showBioData()
    }
    private let termsAttrText = AttributedStringBuilder()
        .text("By proceeding you agree to our ", attributes: [.textColor(.aLabel), .font(.primaryRegular(15))])
        .text("Terms of Use ", attributes: [.textColor(.primary), .font(.primaryRegular(15))])
        .text("and ", attributes: [.textColor(.aLabel), .font(.primaryRegular(15))])
        .text("Privacy Policy", attributes: [.textColor(.primary), .font(.primaryRegular(15))])
        .attributedString
    private lazy var termsLabel = UILabel(attributedText: termsAttrText)
    private lazy var contentStackView = VStackView(
        subviews: [countryPickerView, continueButton, termsLabel],
        spacing: 20
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        with(contentStackView) {
            addSubview($0)
            $0.centerYInSuperview()
            $0.anchor(
                leading: safeAreaLeadingAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(leftRight: 16)
            )
        }
    }
    
    private func showBioData() {
        
    }
    
    override func addTapGestures() {
        termsLabel.didTap()
        countryPickerView.valueView.didTap()
    }

}
