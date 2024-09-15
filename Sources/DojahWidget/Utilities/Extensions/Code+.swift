//
//  Code+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit
import Foundation
import CoreLocation

let preference: PreferenceProtocol = PreferenceImpl()

func runAfter(_ delay: Double = 0.5, action: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
        action()
    }
}

func runOnMainThread(action: @escaping () -> Void) {
    DispatchQueue.main.async {
        action()
    }
}

func runOnBackgroundThread(action: @escaping () -> Void) {
    DispatchQueue.global().async {
        action()
    }
}

func randomString(length: Int = 11) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

extension Set {
    var toArray: [Element] {
        return Array(self)
    }
}

extension Collection {
    func chunk(n: Int) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}

extension URL {
    func mapTo<T: Codable>(_ type: T.Type) -> T? {
        try? JSONDecoder().decode(type, from: Data(contentsOf: self))
    }
}

extension Sequence {
    func distinctBy<A: Hashable>(by selector: (Iterator.Element) -> A) -> [Iterator.Element] {
        var set: Set<A> = []
        var list: [Iterator.Element] = []

        forEach { e in
            let key = selector(e)
            if set.insert(key).inserted {
                list.append(e)
            }
        }

        return list
    }
}

extension Collection {
    var isNotEmpty: Bool { !self.isEmpty }
    
    func countEquals(_ number: Int) -> Bool { count == number }
    
    func countNotEqual(to number: Int) -> Bool { count != number }
    
    func countGreaterThan(_ number: Int) -> Bool { count > number }
    
    func countGreaterThanOrEquals(_ number: Int) -> Bool { count >= number }
    
    func countLessThan(_ number: Int) -> Bool { count < number }
    
    func countLessThanOrEquals(_ number: Int) -> Bool { count <= number }
}

extension Optional {
    var isNil : Bool {
        self == nil
    }
    
    var isNotNil : Bool {
        self != nil
    }
}

extension Optional where Wrapped == [Array<Any>] {
    var orEmptyList: [Any] { isNil ? [] : self! }
}

extension Optional where Wrapped == Int {
    var orZero: Int { isNil ? 0 : self! }
    
    var described: String {
        String(describing: self)
    }
}

extension Optional where Wrapped == Double {
    var orZero: Double { isNil ? 0.double : self! }
    
    var described: String {
        String(describing: self)
    }
}

extension Optional where Wrapped == Number {
    var orZero: Int { (isNil ? 0 : self!) as! Int }
    
    var described: String {
        String(describing: self)
    }
}

extension Optional where Wrapped == String {
    var orEmpty: String {
        self?.isEmpty ?? true ? "" : self!
    }
    
    var described: String {
        String(describing: self)
    }
}

func openURL(url: String) {
    if let url = URL(string: url) {
        UIApplication.shared.open(url)
    }
}

func canOpenURL(url: String) -> Bool {
    if let url = URL(string: url) {
        return UIApplication.shared.canOpenURL(url)
    }
    return false
}

func keepDeviceAwake(_ keepAwake: Bool) {
    UIApplication.shared.isIdleTimerDisabled = keepAwake
}

var appVersion: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}

func makePhoneCall(_ phoneNumber: String, errorHandler: NoParamHandler? = nil) {
    let phoneURLString = "telprompt://\(phoneNumber)"
    let phoneFallbackURLString = "tel://\(phoneNumber)"
    
    if canOpenURL(url: phoneURLString) {
        openURL(url: phoneURLString)
    } else if canOpenURL(url: phoneFallbackURLString) {
        openURL(url: phoneFallbackURLString)
    } else {
        errorHandler?()
    }
}

extension Dictionary {
    mutating func merge<K, V>(_ dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
    
    init(_ slice: Slice<Dictionary>) {
        self = [:]
        
        for (key, value) in slice {
            self[key] = value
        }
    }
    
    func containKey(_ key: Key) -> Bool {
        return index(forKey: key) == nil ? false : true
    }
    
}

func generateHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

var notchHeight: CGFloat { UIApplication.shared.statusBarFrame.height }

extension Array where Element: Equatable {
    func doesNotContain(_ element: Element) -> Bool {
        return !contains(element)
    }
}

extension Dictionary {
    mutating func merge(_ dict: [Key: Value]) -> Self {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
        return self
    }
}

func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>) -> Dictionary<K,V> {
    var map = Dictionary<K,V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}

extension NSObject {
    /// Returns class name stripped from module name.
    class var className: String {
        let namespaceClassName = String(describing: self)
        return namespaceClassName.components(separatedBy: ".").last!
    }
}

var inLightMode: Bool {
    guard let currentWindow = UIApplication.shared.windows.first else { return false }
    return currentWindow.traitCollection.userInterfaceStyle == .light
}

extension CLLocationCoordinate2D {
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var latLngString: String {
        "Lat: \(latitude), Lng: \(longitude)"
    }
}

extension CLLocation {
    var latLngString: String {
        coordinate.latLngString
    }
}
