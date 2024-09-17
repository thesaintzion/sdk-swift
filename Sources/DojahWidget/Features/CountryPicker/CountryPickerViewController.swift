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
        kviewModel = viewModel
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let iconConfig = IconConfig(
        icon: .res("ngFlag"),
        size: .init(width: 19, height: 14),
        contentMode: .scaleAspectFill
    )
    private lazy var countryPickerView = DJPickerView(
        title: "Select a country",
        value: "Nigeria",
        leftIconConfig: iconConfig
    )
    private lazy var countriesTableView = UITableView(
        cells: [UITableViewCell.self],
        delegate: self,
        datasource: self,
        scrollable: true
    )
    private let searchTextField = DJTextField(
        title: "",
        placeholder: "Search"
    )
    private lazy var countriesContainerView = UIView(
        subviews: [searchTextField, countriesTableView],
        height: 400,
        backgroundColor: .white,
        borderWidth: 1,
        borderColor: .djBorder,
        radius: 5
    )
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.viewModel.didTapContinue()
    }
    private lazy var termsView = TermsAndPrivacyView(delegate: self)
    private lazy var contentStackView = VStackView(
        subviews: [countryPickerView, countriesContainerView, UIView.vspacer(20), continueButton, termsView],
        spacing: 30
    )
    private lazy var contentScrollView = UIScrollView(children: [contentStackView])
    private var showCountries = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewProtocol = self
        with(contentScrollView) {
            addSubview($0)
            
            $0.anchor(
                top: navView.bottomAnchor,
                leading: safeAreaLeadingAnchor,
                bottom: poweredView.topAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(left: 20, bottom: 20, right: 20)
            )
            
            contentStackView.anchor(
                top: $0.ktopAnchor,
                leading: $0.kleadingAnchor,
                bottom: $0.kbottomAnchor,
                trailing: $0.ktrailingAnchor,
                padding: .kinit(top: 50, bottom: 20)
            )
        }
        
        with(contentStackView) {
            $0.setCustomSpacing(5, after: countryPickerView)
            $0.setCustomSpacing(15, after: countriesContainerView)
        }
        
        with(countriesContainerView) {
            $0.applyShadow(radius: 5)
            $0.showView(false)
            
            searchTextField.anchor(
                top: $0.topAnchor,
                leading: $0.leadingAnchor,
                trailing: $0.trailingAnchor,
                padding: .kinit(topBottom: 7, leftRight: 12)
            )
            
            countriesTableView.anchor(
                top: searchTextField.bottomAnchor,
                leading: $0.leadingAnchor,
                bottom: $0.bottomAnchor,
                trailing: $0.trailingAnchor,
                padding: .kinit(top: -15, bottom: 20)
            )
            
            countriesTableView.clearBackground()
        }
        
        searchTextField.textField.addTarget(
            self,
            action: #selector(searchTextfieldDidChange),
            for: .editingChanged
        )
    }
    
    override func addTapGestures() {
        countryPickerView.valueView.didTap { [weak self] in
            guard let self else { return }
            self.showCountries.toggle()
            self.showCountriesContainer(self.showCountries)
        }
    }
    
    @objc private func searchTextfieldDidChange() {
        viewModel.filterCountries(searchTextField.text)
    }
    
    private func didChooseCountry(_ country: DJCountryDB) {
        countryPickerView.updateInfo(country: country)
        viewModel.didChooseCountry(country)
        showCountriesContainer(false)
        searchTextField.text = ""
    }

    private func showCountriesContainer(_ show: Bool = true) {
        countriesContainerView.showView(show)
    }
}

extension CountryPickerViewController: CountryPickerViewProtocol {
    func refreshCountries() {
        countriesTableView.reloadData()
    }
    
    func showErrorMessage(_ message: String) {
        navView.showErrorMessage(message)
    }
    
    func hideMessage() {
        navView.hideMessage()
    }
    
    func enableContinueButton(_ enable: Bool) {
        continueButton.enable(enable)
    }
}

extension CountryPickerViewController: UITableViewConformable {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = viewModel.countries[indexPath.row]
        return with(tableView.deque(cell: UITableViewCell.self, at: indexPath)) {
            $0.clearBackground()
            $0.textLabel?.numberOfLines = 0
            $0.textLabel?.text = country.emoticonCountryName
            $0.didTap { [weak self] in
                self?.didChooseCountry(country)
            }
        }
    }
}

extension CountryPickerViewController: TermsAndPrivacyViewDelegate {
    func didTapTerms() {}
    
    func didTapPrivacy() {}
}
