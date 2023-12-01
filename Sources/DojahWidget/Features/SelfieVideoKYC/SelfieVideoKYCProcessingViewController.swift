//
//  SelfieVideoKYCProcessingViewController.swift
//
//
//  Created by Isaac Iniongun on 16/11/2023.
//

import UIKit

final class SelfieVideoKYCProcessingViewController: DJBaseViewController {

    private let viewModel: SelfieVideoKYCViewModel
    
    init(viewModel: SelfieVideoKYCViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let processingImageView = UIImageView(
        image: .res(.processing),
        contentMode: .scaleAspectFill,
        size: 250,
        cornerRadius: 125
    )
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.didTapContinueButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [processingImageView.withHStackCentering(), continueButton],
        spacing: 40
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        with(contentStackView) {
            addSubview($0)
            $0.centerYInSuperview()
            $0.anchor(
                leading: safeAreaLeadingAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(leftRight: 20)
            )
        }
    }
    
    private func didTapContinueButton() {
        showFeedbackController(
            title: "ID Verification Success",
            message: "Your identification has been successfully verified, you will now be redirected"
        ) { [weak self] in
            self?.popToViewController(ofClass: DojahWidgetViewController.self)
        }
    }
    
}
