//
//  BaseTableViewCell.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    open func setup() {
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func kaddSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
    
    func kaddSubviews(_ views: [UIView]) {
        contentView.addSubviews(views)
    }
    
    func kaddSubviews(_ views: UIView...) {
        contentView.addSubviews(views)
    }
    
    var ktopAnchor: NSLayoutYAxisAnchor? { contentView.topAnchor }
    
    var kbottomAnchor: NSLayoutYAxisAnchor? { contentView.bottomAnchor }
    
    var kleadingAnchor: NSLayoutXAxisAnchor? { contentView.leadingAnchor }
    
    var ktrailingAnchor: NSLayoutXAxisAnchor? { contentView.trailingAnchor }
}
