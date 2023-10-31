//
//  FeedbackViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

enum FeedbackType {
    case success, failure
    
    var icon: UIImage {
        switch self {
        case .success:
            return .res(.purpleSuccessCheckmark)
        case .failure:
            return .res(.xCircle)
        }
    }
}

final class FeedbackViewController: DJBaseViewController {
    
    private let feedbackType: FeedbackType
    private let message: String
    private let doneAction: NoParamHandler?
    
    init(feedbackType: FeedbackType, message: String, doneAction: NoParamHandler? = nil) {
        self.feedbackType = feedbackType
        self.message = message
        self.doneAction = doneAction
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var iconImageView = UIImageView(image: feedbackType.icon, height: 100)
    private lazy var messageLabel = UILabel(
        text: message,
        font: .regular(16),
        numberOfLines: 0,
        alignment: .center
    )
    private lazy var doneButton = DJButton(title: "Done") { [weak self] in
        self?.didTapDoneButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [iconImageView, messageLabel, doneButton],
        spacing: 20
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        with(contentStackView) {
            addSubview($0)
            $0.anchor(
                top: navView.bottomAnchor,
                leading: safeAreaLeadingAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(topBottom: 50, leftRight: 20)
            )
            $0.setCustomSpacing(50, after: messageLabel)
        }
    }
    
    private func didTapDoneButton() {
        doneAction?()
    }

}
