//
//  LoaderViewController.swift
//
//
//  Created by Isaac Iniongun on 08/12/2023.
//

import UIKit
import Lottie

final class LoaderViewController: UIViewController {
    
    private let animationView = LottieAnimationView(
        name: "circle-loader",
        bundle: Bundle.module
    ).withSize(width: 200, height: 150)
    private let messageLabel = UILabel(
        text: "Please wait, your information is\nbeing processed",
        font: .regular(16),
        numberOfLines: 0,
        alignment: .center
    )
    private lazy var contentStackView = VStackView(subviews: [animationView, messageLabel], spacing: 10)
    private lazy var contentView = UIView(
        subviews: [contentStackView],
        backgroundColor: .white,
        radius: 10
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInterfaceStyle()
        setBackgroundColor(.black.withAlphaComponent(0.3))
        
        with(animationView) {
            addSubview($0)
            $0.centerInSuperview()
            $0.loopMode = .loop
        }
        
        /*with(contentView) {
            addSubview($0)
            $0.centerYInSuperview()
            $0.anchor(
                leading: safeAreaLeadingAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(leftRight: 20)
            )
        }
        contentStackView.fillSuperview(padding: .kinit(left: 20, bottom: 40, right: 20))
        
        animationView.loopMode = .loop*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }

}
