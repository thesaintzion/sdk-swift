//
//  CountryPickerViewController.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class CountryPickerViewController: DJBaseViewController {

    private let iconConfig = IconConfig(
        icon: .res(.ngFlag),
        size: .init(width: 19, height: 14),
        contentMode: .scaleAspectFill
    )
    private lazy var countryPickerView = DJPickerView(
        title: "Select a country",
        value: "Nigeria",
        leftIconConfig: iconConfig,
        items: Country.allCases.names,
        itemSelectionHandler: didChooseCountry
    )
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.showBioData()
    }
    private lazy var termsView = TermsAndPrivacyView(delegate: self)
    private lazy var contentStackView = VStackView(
        subviews: [countryPickerView, continueButton, termsView],
        spacing: 30
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        with(contentStackView) {
            addSubview($0)
            $0.anchor(
                top: navView.bottomAnchor,
                leading: safeAreaLeadingAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(topBottom: 50, leftRight: 16)
            )
        }
    }
    
    private func showBioData() {
        kpushViewController(BioDataViewController())
    }
    
    private func didChooseCountry(name: String, index: Int) {
        guard let country = Country(rawValue: index) else { return }
        countryPickerView.updateInfo(country: country)
    }

}

extension CountryPickerViewController: TermsAndPrivacyViewDelegate {
    func didTapTerms() {
        
    }
    
    func didTapPrivacy() {
        
    }
}
