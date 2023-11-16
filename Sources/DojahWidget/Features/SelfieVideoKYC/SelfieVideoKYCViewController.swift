//
//  SelfieVideoKYCViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class SelfieVideoKYCViewController: DJBaseViewController {

    private let viewModel: SelfieVideoKYCViewModel
    private var viewState = SelfieVideoKYCViewState.captureRecord
    
    init(viewModel: SelfieVideoKYCViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel = UILabel(
        text: "Preview Captured Media",
        font: .medium(17),
        alignment: .center
    )
    private lazy var topHintView = PillTextView(
        text: "Place your face in the circle and click \(viewModel.verificationMethod.kycText)",
        textColor: .white,
        bgColor: .black
    )
    private let selfieImageView = UIImageView(
        image: .res(.femaleSelfie),
        contentMode: .scaleAspectFill,
        size: 250,
        cornerRadius: 125
    )
    private let bottomHintView = PillIconTextView(
        text: "Please make sure you are in a well lit environment",
        font: .light(13),
        icon: .res(.redInfoCircle),
        iconSize: 18,
        textColor: .djRed,
        bgColor: .djLightRed,
        cornerRadius: 15
    )
    private let disclaimerItemsView = DisclaimerItemsView(items: DJConstants.selfieCaptureDisclaimerItems)
    private lazy var primaryButton = DJButton(title: "\(viewModel.verificationMethod.kycText)") { [weak self] in
        self?.didTapPrimaryButton()
    }
    private lazy var secondaryButton = DJButton(
        title: "Retake",
        font: .medium(15),
        backgroundColor: .primaryGrey,
        textColor: .aLabel,
        borderWidth: 1,
        borderColor: .djBorder
    ) { [weak self] in
        self?.didTapSecondaryButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [titleLabel, topHintView.withHStackCentering(), selfieImageView.withHStackCentering(), bottomHintView.withHStackCentering(), disclaimerItemsView, secondaryButton, primaryButton],
        spacing: 40
    )
    private lazy var contentScrollView = UIScrollView(children: [contentStackView])
    private let attachmentManager = AttachmentManager.shared
    
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
            contentStackView.setCustomSpacing(15, after: secondaryButton)
            contentStackView.setCustomSpacing(15, after: disclaimerItemsView)
        }
        
        [titleLabel, disclaimerItemsView, secondaryButton].showViews(false)
        
        attachmentManager.imagePickedHandler = { [weak self] uiimage, imageURL, sourceType in
            self?.didPickImage(uiimage, at: imageURL, using: sourceType)
        }
    }
    
    private func didPickImage(
        _ uiimage: UIImage,
        at imageURL: URL?,
        using sourceType: UIImagePickerController.SourceType
    ) {
        selfieImageView.image = uiimage
        [titleLabel, disclaimerItemsView, secondaryButton].showViews()
        [topHintView, bottomHintView].showViews(false)
        updateViewState()
    }
    
    private func updateViewState() {
        switch viewState {
        case .captureRecord:
            viewState = .preview
        case .preview:
            break
        }
        updateUIState()
    }
    
    private func updateUIState() {
        primaryButton.title = viewState.primaryButtonTitle
    }
    
    private func didTapPrimaryButton() {
        switch viewState {
        case .captureRecord:
            attachmentManager.openPhotoLibrary(on: self)
        case .preview:
            let controller = SelfieVideoKYCProcessingViewController(viewModel: viewModel)
            kpushViewController(controller)
        }
    }
    
    private func didTapSecondaryButton() {
        
    }

}
