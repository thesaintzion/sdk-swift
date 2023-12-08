//
//  FeedbackViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit
import Lottie

final class FeedbackViewController: DJBaseViewController {
    
    private let config: FeedbackConfig
    
    init(config: FeedbackConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var animationView = LottieAnimationView(name: config.feedbackType.lottieAnimationName, bundle: Bundle.module).withSize(200)
    private lazy var titleLabel = UILabel(text: config.titleText, font: .semibold(20), alignment: .center)
    private lazy var messageLabel = UILabel(
        text: config.message,
        font: .regular(16),
        numberOfLines: 0,
        alignment: .center
    )
    private lazy var doneButton = DJButton(title: "Done") { [weak self] in
        self?.didTapDoneButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [titleLabel, animationView, messageLabel, doneButton],
        spacing: 10,
        alignment: .center
    )
    
    override func viewDidLoad() {
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
        
        with(doneButton) {
            addSubview($0)
            $0.anchor(
                leading: safeAreaLeadingAnchor,
                bottom: poweredView.topAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(topBottom: 50, leftRight: 20)
            )
        }
        
        with(animationView) {
            $0.loopMode = .loop
            $0.play()
        }
    }
    
    private func didTapDoneButton() {
        config.doneAction?()
    }

}
