//
//  TermsAndPrivacyView.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

protocol TermsAndPrivacyViewDelegate: AnyObject {
    func didTapTerms()
    func didTapPrivacy()
}

final class TermsAndPrivacyView: BaseView {

    weak var delegate: TermsAndPrivacyViewDelegate?
    private let proceedingLabel = UILabel(text: "By proceeding you agree to our")
    private lazy var termsButton = DJButton(
        title: "Terms of Use",
        font: .regular(15),
        backgroundColor: .clear,
        textColor: .primary,
        height: nil
    ) { [weak self] in
        self?.delegate?.didTapTerms()
    }
    private lazy var termsStackView = HStackView(
        subviews: [proceedingLabel, termsButton],
        spacing: 3, 
        alignment: .center
    )
    private let andLabel = UILabel(text: "and")
    private lazy var privacyButton = DJButton(
        title: "Privacy Policy",
        font: .regular(15),
        backgroundColor: .clear,
        textColor: .primary,
        height: nil
    ) { [weak self] in
        self?.delegate?.didTapPrivacy()
    }
    private lazy var privacyStackView = HStackView(
        subviews: [andLabel, privacyButton],
        spacing: 3,
        alignment: .center
    )
    private lazy var contentStackView = VStackView(
        subviews: [termsStackView, privacyStackView],
        alignment: .center
    )
    
    init(delegate: TermsAndPrivacyViewDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        with(contentStackView) {
            addSubview($0)
            $0.fillSuperview()
        }
    }

}
