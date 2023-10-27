//
//  DojahWidgetViewController.swift
//  
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

public class DojahWidgetViewController: UIViewController {
    
    private let navView = DJNavBarView()
    private let circleImageView = UIImageView(image: .res(.circleIcon), height: 60)
    private let disclaimerTitleLabel = UILabel(
        text: "Please note the following",
        font: .primarySemibold(15),
        alignment: .left
    )
    private lazy var disclaimerItemsTableView = UITableView(
        cells: [DisclaimerCell.self],
        delegate: self,
        datasource: self,
        scrollable: false
    )
    private lazy var disclaimerStackView = VStackView(
        subviews: [disclaimerTitleLabel, disclaimerItemsTableView],
        spacing: 15
    )
    private lazy var disclaimerView = UIView(
        subviews: [disclaimerStackView],
        backgroundColor: .primaryGrey,
        radius: 4
    )
    private lazy var continueButton = DJButton(title: "Continue")
    private lazy var contentStackView = VStackView(
        subviews: [circleImageView, disclaimerView, continueButton],
        spacing: 30
    )
    private let poweredView = DJPoweredView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavBar(false)
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubviews(navView, contentStackView, poweredView)
        
        navView.anchor(
            top: safeAreaTopAnchor,
            leading: safeAreaLeadingAnchor,
            trailing: safeAreaTrailingAnchor,
            padding: .kinit(topBottom: 15, leftRight: 16)
        )
        navView.delegate = self
        
        contentStackView.anchor(
            top: navView.bottomAnchor,
            leading: safeAreaLeadingAnchor,
            trailing: safeAreaTrailingAnchor,
            padding: .kinit(topBottom: 30, leftRight: 16)
        )
        
        with(poweredView) {
            $0.centerHorizontallyInSuperview()
            $0.anchor(
                bottom: safeAreaBottomAnchor,
                padding: .kinit(bottom: 10)
            )
        }
        
        disclaimerStackView.fillSuperview(padding: .kinit(topBottom: 15, leftRight: 10))
        disclaimerItemsTableView.constraintHeight(200)
        
        addTapGestures()
    }
    
    private func addTapGestures() {
        continueButton.tapAction = { [weak self] in
            
        }
    }

}

extension DojahWidgetViewController: DJNavBarViewDelegate {
    func didTapBack() {
        
    }
    
    func didDismiss() {
        
    }
}

extension DojahWidgetViewController: UITableViewConformable {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DJConstants.disclaimerItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoText = DJConstants.disclaimerItems[indexPath.row]
        let cell = tableView.deque(cell: DisclaimerCell.self, at: indexPath)
        cell.infoLabel.text = infoText
        return cell
    }
}
