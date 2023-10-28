//
//  CountryPickerViewController.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class CountryPickerViewController: DJBaseViewController {

    private let countryPickerView = DJPickerView(
        title: "Select a country",
        value: "Nigeria",
        leftIcon: .res(.ngFlag),
        leftIconSize: .init(width: 19, height: 14)
    )
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.showBioData()
    }
    private lazy var termsView = TermsAndPrivacyView(delegate: self)
    private lazy var contentStackView = VStackView(
        subviews: [countryPickerView, continueButton, termsView],
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
        kpushViewController(BioDataViewController())
    }
    
    override func addTapGestures() {
        countryPickerView.valueView.didTap { [weak self] in
            self?.showCountries()
        }
    }
    
    private func showCountries() {
        let viewController = CountriesViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }

}

extension CountryPickerViewController: CountriesViewDelegate {
    func didChooseCountry(_ country: Country) {
        countryPickerView.updateInfo(country: country)
    }
}

extension CountryPickerViewController: TermsAndPrivacyViewDelegate {
    func didTapTerms() {
        
    }
    
    func didTapPrivacy() {
        
    }
}
