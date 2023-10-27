//
//  UIImageView+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UIImageView {
    func setImageFromURL(url: String, placeholderImage: UIImage? = nil) {
        //sd_setImage(with: URL(string: url), placeholderImage: placeholderImage)
    }
    
    func setImageColor(_ color: UIColor) {
      let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
      self.image = templateImage
      self.tintColor = color
    }
      
    convenience init(
        image: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        tintColor: UIColor? = nil,
        size: CGFloat? = nil,
        height: CGFloat? = nil,
        width: CGFloat? = nil,
        cornerRadius: CGFloat? = nil
    ) {
        self.init(image: image)
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        self.contentMode = contentMode
        if let size = size {
            constraintSize(size)
        }
        if let height = height {
            constraintHeight(height)
        }
        if let width = width {
            constraintWidth(width)
        }
        if let cornerRadius = cornerRadius {
            viewCornerRadius = cornerRadius
        }
    }
}
