//
//  BusinessIDViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class BusinessDataViewController: DJBaseViewController {
    
    private let viewModel: BusinessDataViewModel
    
    init(viewModel: BusinessDataViewModel = BusinessDataViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        kviewModel = viewModel
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var documentTypeView = DJPickerView(
        title: "Document Type",
        items: viewModel.documentTypes.names,
        itemSelectionHandler: { [weak self] _, index in
            self?.continueButton.enable()
            self?.viewModel.didChooseDocumentType(at: index)
        }
    )
    private let documentNumberTextField = DJTextField(
        title: "Document Number",
        validationType: .alphaNumeric
    )
    private let businessNameTextField = DJTextField(
        title: "Business Name",
        placeholder: "Business name",
        validationType: .name
    )
    private lazy var continueButton = DJButton(title: "Continue", isEnabled: false) { [weak self] in
        self?.didTapContinueButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [documentTypeView, documentNumberTextField, businessNameTextField, continueButton],
        spacing: 40
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
        
        [documentNumberTextField, businessNameTextField].showViews(false)
        
        viewModel.viewProtocol = self
        
    }
    
    private func didTapContinueButton() {
        if [businessNameTextField, documentNumberTextField].areValid {
            viewModel.verifyBusiness(
                name: businessNameTextField.text,
                number: documentNumberTextField.text
            )
        }
    }
    
}

extension BusinessDataViewController: BusinessDataViewProtocol {
    func updateNumberTextfield() {
        guard let selectedDocument = viewModel.selectedDocument else { return }
        continueButton.enable()
        documentTypeView.updateValue(selectedDocument.name.orEmpty)
        with(documentNumberTextField) {
            $0.textField.placeholder = selectedDocument.placeholder.orEmpty
            $0.title = selectedDocument.idEnum.orEmpty
            $0.showView()
        }
        businessNameTextField.showView()
    }
    
    func showErrorMessage(_ message: String) {
        navView.showErrorMessage(message)
    }
    
    func hideMessage() {
        navView.hideMessage()
    }
}
