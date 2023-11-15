//
//  UIScrollView+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UIScrollView {
    convenience init(
        children: [UIView],
        showsVerticalScrollIndicator: Bool = true,
        showsHorizontalScrollIndicator: Bool = true
    ) {
        self.init(frame: .zero)
        addSubviews(children)
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
    }
    
    func updateContentView(_ offset: CGFloat = 50) {
        contentSize.height = (subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height) + offset
    }
    
    func showIndicators(_ show: Bool = true) {
        showsVerticalScrollIndicator = show
        showsHorizontalScrollIndicator = show
    }
    
    var ktopAnchor: NSLayoutYAxisAnchor? { contentLayoutGuide.topAnchor }
    
    var kbottomAnchor: NSLayoutYAxisAnchor? { contentLayoutGuide.bottomAnchor }
    
    var kleadingAnchor: NSLayoutXAxisAnchor? { frameLayoutGuide.leadingAnchor }
    
    var ktrailingAnchor: NSLayoutXAxisAnchor? { frameLayoutGuide.trailingAnchor }
    
    func fillView(with view: UIView, padding: UIEdgeInsets = .zero) {
        view.anchor(
            top: ktopAnchor,
            leading: kleadingAnchor,
            bottom: kbottomAnchor,
            trailing: ktrailingAnchor,
            padding: padding
        )
    }
}
