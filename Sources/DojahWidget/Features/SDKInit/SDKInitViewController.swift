//
//  SDKInitViewController.swift
//  
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import UIKit
import Lottie

final class SDKInitViewController: UIViewController {
    
    private let viewModel: SDKInitViewModel
    
    init(viewModel: SDKInitViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let animationView = LottieAnimationView(name: "circle-loader", bundle: DojahBundle.bundle).withSize(200)
    private let messageLabel = UILabel(text: "Initializing Dojah Widget SDK...", font: .medium(20), alignment: .center)
    private lazy var contentStackView = VStackView(subviews: [animationView, messageLabel], spacing: 10)

    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBar(false)
        setUserInterfaceStyle()
        setBackgroundColor()
        viewModel.viewProtocol = self
        
        with(contentStackView) {
            addSubview($0)
            $0.centerInSuperview()
        }
        
        animationView.loopMode = .loop
        animationView.play()
        
        viewModel.initialize()
    }

}

extension SDKInitViewController: SDKInitViewProtocol {
    func showLoader(_ show: Bool) {
        runOnMainThread { [weak self] in
            if show {
                self?.animationView.play()
            } else {
                self?.animationView.stop()
            }
        }
    }
    
    func showSDKInitFailedView() {
        let config: FeedbackConfig = .error(
            titleText: "SDK Initialization Failed",
            message: "Unable to initialize Dojah Widget SDK, please try again or contact support.",
            doneAction: { [weak self] in
                self?.kpopToRoot()
            }
        )
        showFeedbackController(config: config)
    }
    
    func showCountryNotSupportedError() {
        let config: FeedbackConfig = .init(
            feedbackType: .countryNotSupported,
            titleText: "",
            message: "Verification is not allowed in\nyour country",
            doneAction: { [weak self] in
                self?.kpopToRoot()
            }
        )
        showFeedbackController(config: config)
    }
    
    func showDisclaimer() {
        let controller = DJDisclaimerViewController()
        kpush(controller)
    }
    
    func showVerificationSuccessful() {
        let config: FeedbackConfig = .success(
            titleText: "Verification successful",
            message: "Your identification has been successfully verified.",
            doneAction: { [weak self] in
                self?.kpopToRoot()
            }
        )
        showFeedbackController(config: config)
    }
}
