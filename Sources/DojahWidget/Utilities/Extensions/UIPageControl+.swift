//
//  UIPageControl+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UIPageControl {
    convenience init(
        indicatorColor: UIColor,
        currentPageColor: UIColor,
        numberOfItems: Int = 1,
        transformBy scale: CGFloat = 1.5
    ) {
        self.init()
        pageIndicatorTintColor = indicatorColor
        currentPageIndicatorTintColor = currentPageColor
        numberOfPages = numberOfItems
        transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
