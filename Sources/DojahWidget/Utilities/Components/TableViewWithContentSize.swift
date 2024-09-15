//
//  TableViewWithContentSize.swift
//
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit

final class TableViewWithContentSize: UITableView {
    var didLayoutSubviews: ParamHandler<CGSize>?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        didLayoutSubviews?(contentSize)
    }
}
