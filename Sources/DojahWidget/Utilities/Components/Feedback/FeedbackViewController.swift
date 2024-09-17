//
//  FeedbackViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit
import Lottie

final public class FeedbackViewController: DJBaseViewController {
    
    private let config: FeedbackConfig
    
    init(config: FeedbackConfig = .success(feedbackType: .warning)) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var animationView = LottieAnimationView(
        name: config.feedbackType.lottieAnimationName,
        bundle: DojahBundle.bundle
    ).withHeight(200)
    private lazy var iconImageView = UIImageView(
        image: config.feedbackType.icon,
        size: 80
    )
    private lazy var titleLabel = UILabel(
        text: config.titleText,
        font: .semibold(20),
        alignment: .center
    )
    private lazy var messageLabel = UILabel(
        text: config.message,
        font: .regular(16),
        numberOfLines: 0,
        alignment: .center
    )
    private lazy var contentStackView = VStackView(
        subviews: [titleLabel, animationView, iconImageView, messageLabel],
        spacing: 10,
        alignment: .center
    )
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        navView.showNavControls(config.showNavControls)
        with(contentStackView) {
            addSubview($0)
            $0.anchor(
                top: navView.bottomAnchor,
                leading: safeAreaLeadingAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(topBottom: 100, leftRight: 20)
            )
        }
        
        with(animationView) {
            $0.loopMode = .loop
            $0.play()
        }
        
        let countryNotSupported = config.feedbackType == .countryNotSupported
        iconImageView.showView(countryNotSupported)
        animationView.showView(!countryNotSupported)
        messageLabel.font = countryNotSupported ? .medium(16) : .regular(16)
    }
    
    override func didTapNavBackButton() {
        config.doneAction?()
    }
    
    override func didTapNavCloseButton() {
        config.doneAction?()
    }

}
