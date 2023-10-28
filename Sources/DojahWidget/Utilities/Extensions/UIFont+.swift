//
//  UIFont+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UIFont {
    class func semibold(_ size: CGFloat = 14) -> UIFont {
        .djFont(.semibold, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func bold(_ size: CGFloat = 14) -> UIFont {
        .djFont(.bold, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func regular(_ size: CGFloat = 14) -> UIFont {
        .djFont(.regular, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func medium(_ size: CGFloat = 14) -> UIFont {
        .djFont(.medium, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func light(_ size: CGFloat = 14) -> UIFont {
        .djFont(.light, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func djFont(_ font: DJFont, size: CGFloat = 14) -> UIFont? {
        UIFont(name: font.name, size: size)
    }
    
}
