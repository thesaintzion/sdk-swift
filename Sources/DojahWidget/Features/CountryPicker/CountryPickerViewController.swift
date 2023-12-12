//
//  CountryPickerViewController.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class CountryPickerViewController: DJBaseViewController {
    
    private let viewModel: CountryPickerViewModel
    
    init(viewModel: CountryPickerViewModel = CountryPickerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let iconConfig = IconConfig(
        icon: .res(.ngFlag),
        size: .init(width: 19, height: 14),
        contentMode: .scaleAspectFill
    )
    private lazy var countryPickerView = DJPickerView(
        title: "Select a country",
        value: "Nigeria",
        leftIconConfig: iconConfig,
        items: viewModel.countryNames,
        showSelectedItem: false,
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
        kpush(BioDataViewController())
    }
    
    private func didChooseCountry(name: String, index: Int) {
        countryPickerView.updateInfo(country: viewModel.country(at: index))
        viewModel.didSelectCountry(at: index)
    }

}

extension CountryPickerViewController: TermsAndPrivacyViewDelegate {
    func didTapTerms() {
        
    }
    
    func didTapPrivacy() {
        
    }
}
