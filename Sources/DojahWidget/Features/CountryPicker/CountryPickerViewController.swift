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
        leftIconConfig: iconConfig
    )
    private lazy var countryPickerTextfield = DJTextField(
        title: "Select a country",
        placeholder: "Select",
        items: Country.allCases.map { $0.name },
        leftIconConfig: iconConfig,
        itemSelectionHandler: didChooseCountry
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
        showSelectableItemsViewController(
            title: "Choose Country",
            items: Country.allCases,
            height: 220,
            delegate: self
        )
    }
    
    private func didChooseCountry(index: Int, name: String) {
        guard let country = Country(rawValue: index) else { return }
        with(countryPickerTextfield) {
            $0.text = country.name
            $0.leftIconImageView.image = country.flag
        }
    }

}

extension CountryPickerViewController: TermsAndPrivacyViewDelegate {
    func didTapTerms() {
        
    }
    
    func didTapPrivacy() {
        
    }
}

extension CountryPickerViewController: SelectableItemsViewDelegate {
    func didChooseItem(_ item: SelectableItem) {
        if let country = item as? Country {
            countryPickerView.updateInfo(country: country)
        }
    }
}
