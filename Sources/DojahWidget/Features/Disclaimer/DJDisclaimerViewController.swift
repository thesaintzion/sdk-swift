//
//  DJDisclaimerViewController.swift
//  
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

class DJDisclaimerViewController: DJBaseViewController {
    
    private let viewModel: DJDisclaimerViewModel
    
    init(viewModel: DJDisclaimerViewModel = DJDisclaimerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        kviewModel = viewModel
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let circleImageView = UIImageView(image: .res(.circleIcon), height: 60)
    private let disclaimerTitleLabel = UILabel(
        text: "Please note the following",
        font: .medium(15),
        alignment: .left
    )
    private let disclaimerItemsView = DisclaimerItemsView(items: DJConstants.disclaimerItems)
    private lazy var disclaimerStackView = VStackView(
        subviews: [disclaimerTitleLabel, disclaimerItemsView],
        spacing: 10
    )
    private lazy var disclaimerView = UIView(
        subviews: [disclaimerStackView],
        backgroundColor: .primaryGrey,
        radius: 5
    )
    private let continueButton = DJButton(title: "Continue")
    private lazy var contentStackView = VStackView(
        subviews: [circleImageView, disclaimerView, continueButton],
        spacing: 30
    )
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavBar(false)
    }
    
    private func setupUI() {
        addSubviews(navView, contentStackView)
        
        contentStackView.anchor(
            top: navView.bottomAnchor,
            leading: safeAreaLeadingAnchor,
            trailing: safeAreaTrailingAnchor,
            padding: .kinit(topBottom: 60, leftRight: 16)
        )
        
        disclaimerStackView.fillSuperview(padding: .kinit(topBottom: 15, leftRight: 20))
        
        addTapGestures()
    }
    
    internal override func addTapGestures() {
        continueButton.tapAction = { [weak self] in
            self?.viewModel.postStepCompletedEvent()
        }
    }
    
    private func showCountryPicker() {
        if viewModel.canSeeCountryPage {
            let viewController = CountryPickerViewController()
            kpush(viewController)
        } else {
            
        }
    }
}

extension DJDisclaimerViewController: DJDisclaimerViewProtocol {
    
}
