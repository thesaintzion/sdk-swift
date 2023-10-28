//
//  DojahWidgetViewController.swift
//  
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

public class DojahWidgetViewController: DJBaseViewController {
    
    private let circleImageView = UIImageView(image: .res(.circleIcon), height: 60)
    private let disclaimerTitleLabel = UILabel(
        text: "Please note the following",
        font: .primaryMedium(15),
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
        spacing: 10
    )
    private lazy var disclaimerView = UIView(
        subviews: [disclaimerStackView],
        backgroundColor: .primaryGrey,
        radius: 5
    )
    private let continueButton = DJButton(title: "Continue")
    private lazy var contentStackView = VStackView(
        subviews: [circleImageView, disclaimerView, continueButton],
        spacing: 30
    )
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavBar(false)
    }
    
    private func setupUI() {
        addSubviews(navView, contentStackView)
        
        contentStackView.anchor(
            top: navView.bottomAnchor,
            leading: safeAreaLeadingAnchor,
            trailing: safeAreaTrailingAnchor,
            padding: .kinit(topBottom: 60, leftRight: 16)
        )
        
        disclaimerStackView.fillSuperview(padding: .kinit(topBottom: 15, leftRight: 20))
        disclaimerItemsTableView.constraintHeight(170)
        disclaimerItemsTableView.clearBackground()
        
        addTapGestures()
    }
    
    internal override func addTapGestures() {
        continueButton.tapAction = { [weak self] in
            self?.showCountryPicker()
        }
    }
    
    private func showCountryPicker() {
        let viewController = CountryPickerViewController()
        kpushViewController(viewController)
    }

}

extension DojahWidgetViewController: UITableViewConformable {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DJConstants.disclaimerItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoText = DJConstants.disclaimerItems[indexPath.row]
        let cell = tableView.deque(cell: DisclaimerCell.self, at: indexPath)
        cell.selectionStyle = .none
        cell.infoLabel.text = infoText
        return cell
    }
}
