//
//  GovtIDCaptureViewController.swift
//  
//
//  Created by Isaac Iniongun on 29/10/2023.
//

import UIKit

final class GovtIDCaptureViewController: DJBaseViewController {
    
    private let viewState: GovtIDCaptureViewState = .uploadFront
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
        contentMode: .scaleAspectFill,
        height: 250,
        cornerRadius: 8
    )
    private lazy var primaryButton = DJButton(title: "Upload") { [weak self] in
        self?.didTapPrimaryButton()
    }
    private lazy var secondaryButton = DJButton(
        title: "Capture instead",
        font: .medium(15),
        backgroundColor: .primaryGrey,
        textColor: .aLabel,
        borderWidth: 1,
        borderColor: .djBorder
    ) { [weak self] in
        self?.didTapSecondaryButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [titleLabel, clickHereView, idImageView, primaryButton, secondaryButton],
        spacing: 20
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
        }
        
        idImageView.showView(false)
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
        idImageView.showView()
        clickHereView.showView(false)
    }
    
    private func didTapPrimaryButton() {
        
    }
    
    private func didTapSecondaryButton() {
        attachmentManager.openCamera(on: self)
    }
    
}
