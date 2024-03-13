//
//  AddressVerificationViewController.swift
//
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit
import GooglePlaces
import CoreLocation

final class AddressVerificationViewController: DJBaseViewController {
    
    private let viewModel: AddressVerificationViewModel
    
    init(viewModel: AddressVerificationViewModel = AddressVerificationViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        kviewModel = viewModel
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let addressTextField = DJTextField(
        title: "Input address",
        placeholder: "3-9 Olu Koleosho Street, off Simbiat Abiola Way.",
        rightIcon: .res(.chevronDown)
    )
    private lazy var resultsTableView = UITableView(
        cells: [UITableViewCell.self],
        delegate: self,
        datasource: self,
        scrollable: true
    )
    private lazy var searchResultsView = UIView(
        subviews: [resultsTableView],
        height: 300,
        backgroundColor: .white,
        borderWidth: 1,
        borderColor: .djBorder,
        radius: 5
    )
    private lazy var continueButton = DJButton(title: "Continue", isEnabled: false) { [weak self] in
        self?.viewModel.didTapContinue()
    }
    private lazy var contentStackView = VStackView(
        subviews: [addressTextField, searchResultsView, continueButton],
        spacing: 40
    )
    private lazy var contentScrollView = UIScrollView(children: [contentStackView])

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewProtocol = self
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
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
        
        with(searchResultsView) {
            $0.applyShadow(radius: 5)
            $0.showView(false)
        }
        
        with(resultsTableView) {
            $0.fillSuperview(padding: .kinit(topBottom: 10))
            $0.clearBackground()
        }
        
        contentStackView.setCustomSpacing(5, after: addressTextField)
        
        locationManager.didUpdateLocation = { [weak self] location in
            self?.viewModel.currentLocation = location
        }
        
        locationManager.startUpdatingLocation()
        
        addressTextField.textField.addTarget(
            self,
            action: #selector(addressTextfieldDidChange),
            for: .editingChanged
        )
    }
    
    override func addTapGestures() {
        super.addTapGestures()
        //TODO: Remove this after changes are confirmed
        /*addressTextField.didTap { [weak self] in
            self?.showPlacesAutocomplete()
        }*/
    }
    
    @objc private func addressTextfieldDidChange() {
        viewModel.findAddress(addressTextField.text)
    }
    
    //TODO: Remove this after changes are confirmed
    private func showPlacesAutocomplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.modalPresentationStyle = .overCurrentContext
        
        // Specify the place data types to return.
        let fields = GMSPlaceField(rawValue: UInt64(GMSPlaceField.all.rawValue))
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        //filter.countries = ["ng", "gh"] // available in only selected countries???
        
        with(autocompleteController) {
            $0.autocompleteFilter = filter
            $0.placeFields = fields
            $0.primaryTextColor = .aLabel
            $0.secondaryTextColor = .aSecondaryLabel
            $0.primaryTextHighlightColor = .primary
            $0.tableCellSeparatorColor = .aSeparator
            $0.tableCellBackgroundColor = .aSystemBackground
            $0.tintColor = .primary
        }
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    private func didChooseGooglePlace(_ place: GMSPlace?) {
        guard let place else {
            showToast(message: "Invalid place selected", type: .error)
            return
        }
        viewModel.selectedPlace = place
        addressTextField.text = place.formattedAddress ?? ""
        continueButton.enable()
    }
    
    private func didChoosePlacePrediction(_ prediction: GMSAutocompletePrediction) {
        addressTextField.text = prediction.attributedFullText.string
        viewModel.didChoosePlacePrediction(prediction)
    }

}

extension AddressVerificationViewController: AddressVerificationViewProtocol {
    func showPlacesResults() {
        searchResultsView.showView(viewModel.placePredictions.isNotEmpty)
        resultsTableView.reloadData()
    }
    
    func enableContinueButton(_ enable: Bool) {
        continueButton.enable(enable)
    }
}

extension AddressVerificationViewController: UITableViewConformable {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.placePredictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prediction = viewModel.placePredictions[indexPath.row]
        return with(tableView.deque(cell: UITableViewCell.self, at: indexPath)) {
            $0.clearBackground()
            $0.textLabel?.numberOfLines = 0
            $0.textLabel?.attributedText = prediction.attributedFullText
            $0.didTap { [weak self] in
                self?.didChoosePlacePrediction(prediction)
            }
        }
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate
//TODO: Remove this after changes are confirmed
extension AddressVerificationViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true) { [weak self] in
            self?.didChooseGooglePlace(place)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        kprint("Error: \(error.localizedDescription)")
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
