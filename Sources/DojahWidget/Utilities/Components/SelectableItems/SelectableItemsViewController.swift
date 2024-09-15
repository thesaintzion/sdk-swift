//
//  SelectableItemsViewController.swift
//
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

protocol SelectableItemsViewDelegate: AnyObject {
    func didChooseItem(_ item: SelectableItem)
}

final class SelectableItemsViewController: BottomPopupViewController {
    weak var delegate: SelectableItemsViewDelegate?
    private let items: [SelectableItem]
    private let height: CGFloat
    
    private let titleLabel = UILabel(
        text: "",
        font: .medium(17),
        alignment: .center
    )
    private lazy var itemsTableView = UITableView(
        cells: [SelectableItemCell.self],
        delegate: self,
        datasource: self,
        scrollable: true
    )
    
    init(
        title: String,
        items: [SelectableItem],
        height: CGFloat, 
        delegate: SelectableItemsViewDelegate? = nil
    ) {
        self.delegate = delegate
        self.items = items
        self.height = height
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInterfaceStyle()
        backgroundColor = .aSystemBackground
        addSubviews(titleLabel, itemsTableView)
        
        titleLabel.anchor(
            top: safeAreaTopAnchor,
            leading: safeAreaLeadingAnchor,
            trailing: safeAreaTrailingAnchor,
            padding: .kinit(topBottom: 15, leftRight: 16)
        )
        
        itemsTableView.anchor(
            top: titleLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: safeAreaBottomAnchor,
            trailing: safeAreaTrailingAnchor,
            padding: .kinit(topBottom: 15, leftRight: 20)
        )
    }
    
    override var popupHeight: CGFloat { height }
    
    override var popupTopCornerRadius: CGFloat { 20 }
    
    private func didChooseItem(_ item: SelectableItem) {
        kdismiss { [weak self] in
            self?.delegate?.didChooseItem(item)
        }
    }

}

extension SelectableItemsViewController: UITableViewConformable {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        return with(tableView.deque(cell: SelectableItemCell.self, at: indexPath)) {
            $0.configure(item: item)
            $0.didTap { [weak self] in
                self?.didChooseItem(item)
            }
        }
    }
}
