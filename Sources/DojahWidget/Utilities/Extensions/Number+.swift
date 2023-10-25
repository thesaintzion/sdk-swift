//
//  Number+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation
import UIKit

extension Numeric {
    var double: Double { Double(truncating: self as! NSNumber) }
    
    var float: Float { Float(truncating: self as! NSNumber) }
    
    var cgfloat: CGFloat { CGFloat(truncating: self as! NSNumber) }
    
    var int: Int { Int(truncating: self as! NSNumber) }
    
    var orNil: String { self == 0 ? "Nil" : "\(self)" }
    
    var orEmpty: String { self == 0 ? "" : "\(self)" }
    
    func string(fractionDigits: Int) -> String {
        let formatter = with(NumberFormatter()) {
            $0.minimumFractionDigits = fractionDigits
            $0.maximumFractionDigits = fractionDigits
        }
        return formatter.string(from: self as! NSNumber) ?? "\(self)"
    }
    
    var string: String { "\(self)" }
    
    var inKobo: Int { int * 100 }
    
    var inNaira: Int { int / 100 }
    
    var percent: String { "\(self)%" }
    
    var percentage: Double { double / 100 }
    
    func currencyFormatted(symbol: String = "", decimalPlaces: Int = 0) -> String {
        let currencyFormatter = with(NumberFormatter()) {
            $0.groupingSeparator = ","
            $0.groupingSize = 3
            $0.usesGroupingSeparator = true
            $0.numberStyle = .none
            $0.minimumFractionDigits = decimalPlaces
            $0.maximumFractionDigits = decimalPlaces
        }
        
        return "\(symbol)\(currencyFormatter.string(from: self as! NSNumber)!)"
    }

    
    func lessThan(_ number: NSNumber) -> Bool { double < number.doubleValue }
    
    func lessThanOrEquals(_ number: NSNumber) -> Bool { double <= number.doubleValue }
    
    func greaterThan(_ number: NSNumber) -> Bool { double > number.doubleValue }
    
    func greaterThanOrEquals(_ number: NSNumber) -> Bool { double >= number.doubleValue }
    
    func equals(_ number: NSNumber) -> Bool { double == number.doubleValue }
    
    func notEquals(_ number: NSNumber) -> Bool { double != number.doubleValue }
    
}

extension CGFloat {
    var double: Double { Double(self) }
}

protocol Number {}

extension Int: Number {}
extension Double: Number {}
extension Float: Number {}
