//
//  GovtIDCaptureViewController.swift
//  
//
//  Created by Isaac Iniongun on 29/10/2023.
//

import UIKit

final class GovtIDCaptureViewController: DJBaseViewController {
    
    private var viewState: GovtIDCaptureViewState = .captureFront
    private lazy var titleLabel = UILabel(
        text: viewState.title,
        font: .medium(16),
        alignment: .center
    )
    private let clickHereAttrText = AttributedStringBuilder()
        .text("Click here to select ", attributes: [.textColor(.primary), .font(.light(14))])
        .text("from ", attributes: [.textColor(.aLabel), .font(.light(14))])
        .newline()
        .text("your device.", attributes: [.textColor(.aLabel), .font(.light(14))])
        .attributedString
    private lazy var clickHereLabel = UILabel(
        attributedText: clickHereAttrText,
        numberOfLines: 0, 
        alignment: .center
    )
    private lazy var clickHereView = DottedBorderView(
        subviews: [clickHereLabel],
        height: 200,
        backgroundColor: .primaryGrey
    )
    private let idImageView = UIImageView(
        image: .res(.driversLicense),
        contentMode: .scaleAspectFill,
        height: 250,
        cornerRadius: 8
    )
    private let disclaimerItemsView = DisclaimerItemsView(items: DJConstants.idCaptureDisclaimerItems)
    private let hintView = PillIconTextView(
        text: "Make sure your International Passport is properly placed, and hold it still for a few seconds",
        font: .light(13),
        icon: .res(.greenInfoCircle),
        iconSize: 18,
        textColor: .djGreen,
        bgColor: .djLightGreen,
        cornerRadius: 20
    )
    private lazy var primaryButton = DJButton(title: viewState.primaryButtonTitle) { [weak self] in
        self?.didTapPrimaryButton()
    }
    private lazy var secondaryButton = DJButton(
        title: viewState.secondaryButtonTitle,
        font: .medium(15),
        backgroundColor: .primaryGrey,
        textColor: .aLabel,
        borderWidth: 1,
        borderColor: .djBorder
    ) { [weak self] in
        self?.didTapSecondaryButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [titleLabel, clickHereView, idImageView, hintView, disclaimerItemsView, primaryButton, secondaryButton],
        spacing: 20
    )
    private lazy var contentScrollView = UIScrollView(children: [contentStackView])
    private let attachmentManager = AttachmentManager.shared
    private let verificationMethod: GovtIDVerificationMethod
    
    init(verificationMethod: GovtIDVerificationMethod) {
        self.verificationMethod = verificationMethod
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
                padding: .kinit(top: 40, bottom: 20)
            )
        }
        
        [clickHereView, disclaimerItemsView].showViews(false)
        clickHereLabel.centerInSuperview()
        
        attachmentManager.imagePickedHandler = { [weak self] uiimage, imageURL, sourceType in
            self?.didPickImage(uiimage, at: imageURL, using: sourceType)
        }
    }
    
    override func addTapGestures() {
        clickHereView.didTap { [weak self] in
            guard let self else { return }
            self.attachmentManager.openPhotoLibrary(on: self)
        }
    }
    
    private func didPickImage(
        _ uiimage: UIImage,
        at imageURL: URL?,
        using sourceType: UIImagePickerController.SourceType
    ) {
        idImageView.image = uiimage
        disclaimerItemsView.showView()
        updateViewState()
    }
    
    private func updateViewState() {
        switch viewState {
        case .uploadFront:
            break
        case .uploadBack:
            break
        case .captureFront:
            viewState = .previewFront
        case .captureBack:
            break
        case .previewFront:
            break
        case .previewBack:
            break
        }
        updateUI()
    }
    
    private func updateUI() {
        titleLabel.text = viewState.title
        primaryButton.title = viewState.primaryButtonTitle
        secondaryButton.title = viewState.secondaryButtonTitle
    }
    
    private func didTapPrimaryButton() {
        switch viewState {
        case .uploadFront:
            break
        case .uploadBack:
            break
        case .captureFront:
            attachmentManager.openCamera(on: self)
        case .captureBack:
            break
        case .previewFront:
            proceed()
        case .previewBack:
            break
        }
    }
    
    private func didTapSecondaryButton() {
        switch viewState {
        case .uploadFront:
            break
        case .uploadBack:
            break
        case .captureFront:
            attachmentManager.openPhotoLibrary(on: self)
        case .captureBack:
            break
        case .previewFront:
            break
        case .previewBack:
            break
        }
    }
    
    private func proceed() {
        let config: FeedbackConfig = .success(
            titleText: "Verification Success",
            message: "Your identification has been successfully verified, you will now be redirected",
            doneAction: { [weak self] in
                self?.popToViewController(ofClass: DJDisclaimerViewController.self)
            }
        )
        showFeedbackController(config: config)
    }
    
}
