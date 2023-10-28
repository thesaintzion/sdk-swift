//
//  UISearchBar+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UISearchBar {
    convenience init(
        placeholder: String = "Search",
        font: UIFont = .regular( 15),
        showsCancelButton: Bool = true,
        searchBarStyle: UISearchBar.Style = .minimal,
        height: CGFloat? = nil,
        delegate: UISearchBarDelegate? = nil
    ) {
        self.init(frame: .zero)
        self.font = font
        self.showsCancelButton = showsCancelButton
        self.searchBarStyle = searchBarStyle
        self.placeholder = placeholder
        self.delegate = delegate
        if let height = height {
            textField?.constraintHeight(height)
        }
    }
    
    func updateAppearance(
        height: CGFloat,
        radius: CGFloat = 8.0,
        backgroundColor: UIColor = .aSecondarySystemBackground,
        borderWidth: CGFloat? = nil,
        borderColor: UIColor? = nil
    ) {
        let image: UIImage? = UIImage.imageWithColor(color: backgroundColor, size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        for subview in self.subviews {
            for subSubViews in subview.subviews {
                if #available(iOS 13.0, *) {
                    for child in subSubViews.subviews {
                        if let textField = child as? UISearchTextField {
                            updateTextFieldAppearance(textField)
                        }
                    }
                    continue
                }
                if let textField = subSubViews as? UITextField {
                    updateTextFieldAppearance(textField)
                }
            }
        }
        
        func updateTextFieldAppearance(_ textfield: UIView) {
            with(textfield) {
                $0.layer.cornerRadius = radius
                $0.clipsToBounds = true
                if let borderColor = borderColor {
                    $0.borderColor = borderColor
                }
                if let borderWidth = borderWidth {
                    $0.viewBorderWidth = borderWidth
                }
            }
        }
    }
    
    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            for view : UIView in (self.subviews[0]).subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
    
    var font: UIFont? {
        get { textField?.font }
        set { textField?.font = newValue }
    }
}
