//
//  UITableView+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UITableView {
    
    convenience init(
        cells: [UITableViewCell.Type],
        showIndicators: Bool = false,
        delegate: UITableViewDelegate? = nil,
        datasource: UITableViewDataSource? = nil,
        separatorStyle: UITableViewCell.SeparatorStyle = .none,
        separatorColor: UIColor = .clear,
        scrollable: Bool = true
    ) {
        self.init()
        self.showIndicators(showIndicators)
        if let delegate = delegate {
            self.delegate = delegate
        }
        if let datasource = datasource {
            self.dataSource = datasource
        }
        self.separatorStyle = separatorStyle
        self.separatorColor = separatorColor
        cells.forEach {
            register($0.self, forCellReuseIdentifier: $0.className)
        }
        isScrollEnabled = scrollable
    }

    func setEmptyMessage(
        _ message: String = "",
        separatorStyle: UITableViewCell.SeparatorStyle = .none
    ) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .aLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .regular( 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.isScrollEnabled = false
        self.separatorStyle = separatorStyle
    }

    func restore(separatorStyle: UITableViewCell.SeparatorStyle = .none) {
        self.backgroundView = nil
        self.isScrollEnabled = true
        self.separatorStyle = separatorStyle
    }
    
    func deque<T: UITableViewCell>(cell: T.Type, at indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: cell.className, for: indexPath) as! T
    }
    
    func scrollable(_ scrollable: Bool = true) {
        isScrollEnabled = scrollable
    }
}
