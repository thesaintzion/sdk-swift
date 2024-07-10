//
//  SignatureViewController.swift
//  
//
//  Created by Isaac Iniongun on 13/02/2024.
//

import UIKit

final class SignatureViewController: DJBaseViewController {
    
    private let viewModel: SignatureViewModel
    
    init(viewModel: SignatureViewModel = SignatureViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        kviewModel = viewModel
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titleLabel = UILabel(
        text: "Sign and confirm information",
        font: .semibold(18),
        alignment: .center
    )
    private lazy var infoLabel = UILabel(
        text: viewModel.signatureInformation,
        numberOfLines: 0,
        alignment: .left
    )
    private let nameTextField = DJTextField(
        title: "Input name to sign and confirm",
        placeholder: "Enter your name",
        validationType: .name
    )
    private lazy var confirmButton = DJButton(title: "I sign and confirm") { [weak self] in
        self?.didTapConfirmButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [titleLabel, infoLabel, nameTextField, confirmButton],
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
        contentStackView.setCustomSpacing(20, after: titleLabel)
        contentStackView.setCustomSpacing(60, after: infoLabel)
    }
    
    private func didTapConfirmButton() {
        if nameTextField.isValid {
            viewModel.confirm(name: nameTextField.text)
        }
    }

}
