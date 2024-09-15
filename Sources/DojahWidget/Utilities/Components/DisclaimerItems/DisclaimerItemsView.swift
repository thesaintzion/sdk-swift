//
//  DisclaimerItemsView.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class DisclaimerItemsView: BaseView {
    
    private let items: [String]
    
    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var itemsTableView = TableViewWithContentSize(
        cells: [DisclaimerCell.self],
        delegate: self,
        datasource: self,
        scrollable: false
    )
    private lazy var itemsTableViewHeightConstraint = itemsTableView.constraintHeight(10)
    
    override func setup() {
        super.setup()
        clearBackground()
        with(itemsTableView) {
            addSubview($0)
            $0.fillSuperview()
            $0.clearBackground()
            $0.didLayoutSubviews = { [weak self] contentSize in
                self?.itemsTableViewHeightConstraint.constant = contentSize.height
            }
        }
    }

}

extension DisclaimerItemsView: UITableViewConformable {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoText = items[indexPath.row]
        let cell = tableView.deque(cell: DisclaimerCell.self, at: indexPath)
        cell.selectionStyle = .none
        cell.infoLabel.text = infoText
        return cell
    }
}
