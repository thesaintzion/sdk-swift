//
//  BaseCollectionViewCell.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    open func setup() {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
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
