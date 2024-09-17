//
//  PermissionsViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class PermissionViewController: DJBaseViewController {
    
    private let permissionType: PermissionType
    private let didAllowPermission: NoParamHandler?
    
    init(permissionType: PermissionType = .camera, didAllowPermission: NoParamHandler? = nil) {
        self.permissionType = permissionType
        self.didAllowPermission = didAllowPermission
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var circleImageView = UIImageView(image: permissionType.icon, height: 60)
    private lazy var titleLabel = UILabel(
        text: "\(permissionType.rawValue) Permission Required",
        font: .medium(17),
        alignment: .center
    )
    private lazy var subtitleLabel = UILabel(
        text: "May We Access Your \(permissionType.rawValue) for Security\nVerification?",
        font: .regular(15),
        numberOfLines: 0,
        alignment: .center
    )
    private lazy var itemsTitleLabel = UILabel(
        text: "To ensure the security and integrity of your account, we request access to your device's \(permissionType.rawValue.lowercased()) for:",
        font: .regular(15),
        numberOfLines: 0
    )
    private lazy var disclaimerItemsView = DisclaimerItemsView(items: permissionType.disclaimerItems)
    private lazy var allowButton = DJButton(title: "Allow Permissions") { [weak self] in
        self?.didTapAllowPermission()
    }
    private let howToAllowIconTextView = IconTextView(
        text: "How to allow permission", 
        font: .medium(15),
        icon: .res("purpleInfoCircleOutlined"),
        iconSize: 18,
        textColor: .primary
    )
    private lazy var contentStackView = VStackView(
        subviews: [circleImageView.withHStackCentering(), titleLabel, subtitleLabel, itemsTitleLabel, disclaimerItemsView, allowButton, howToAllowIconTextView.withHStackCentering()],
        spacing: 15
    )
    private lazy var contentScrollView = UIScrollView(children: [contentStackView])
    
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
                padding: .kinit(top: 50, bottom: 20)
            )
        }
        
        with(contentStackView) {
            $0.setCustomSpacing(40, after: subtitleLabel)
            $0.setCustomSpacing(8, after: itemsTitleLabel)
            $0.setCustomSpacing(25, after: disclaimerItemsView)
            $0.setCustomSpacing(30, after: allowButton)
        }
        
        navView.showNavBackControl(false)
    }
    
    private func didTapAllowPermission() {
        kdismiss { [weak self] in
            self?.didAllowPermission?()
        }
    }
    
    override func addTapGestures() {
        howToAllowIconTextView.didTap()
    }
    
    override func didTapNavCloseButton() {
        kdismiss()
    }

}
