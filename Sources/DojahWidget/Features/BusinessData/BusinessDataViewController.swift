//
//  BusinessIDViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final public class BusinessDataViewController: DJBaseViewController {
    
    public static func newInstance() -> BusinessDataViewController { BusinessDataViewController() }

    private let documentTypeView = DJPickerView(title: "Document type")
    private let documentNumberTextField = DJTextField(title: "Document Number")
    private let businessNameTextField = DJTextField(title: "Business name", placeholder: "Business name")
    private lazy var continueButton = DJButton(title: "Continue") { [weak self] in
        self?.didTapContinueButton()
    }
    private lazy var contentStackView = VStackView(
        subviews: [documentTypeView, documentNumberTextField, businessNameTextField, continueButton],
        spacing: 40
    )
    private lazy var contentScrollView = UIScrollView(children: [contentStackView])
    private var govtID: GovtID?
    
    override public func viewDidLoad() {
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
        
        [documentNumberTextField, businessNameTextField].showViews(false)
        
    }
    
    override func addTapGestures() {
        documentTypeView.valueView.didTap { [weak self] in
            self?.didTapDocumentTypeView()
        }
    }
    
    private func didTapDocumentTypeView() {
        showSelectableItemsViewController(
            title: "Choose Document Type",
            items: GovtID.allCases,
            height: 260,
            delegate: self
        )
    }
    
    private func didTapContinueButton() {
        
    }

}

extension BusinessDataViewController: SelectableItemsViewDelegate {
    func didChooseItem(_ item: SelectableItem) {
        if let govtID = item as? GovtID {
            self.govtID = govtID
            documentTypeView.updateValue(govtID.title)
            with(documentNumberTextField) {
                $0.textField.placeholder = govtID.numberTitle
                $0.title = govtID.numberTitle
                $0.showView()
            }
            businessNameTextField.showView()
        }
    }
}
