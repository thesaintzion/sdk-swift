//
//  Preference+.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation

@propertyWrapper
struct UserDefaultCodable<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let userDefaults = UserDefaults.standard
    
    init(key: PreferenceKey, default: T) {
        self.key = key.rawValue
        self.defaultValue = `default`
    }
    
    var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key) else {
                return defaultValue
            }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: key)
        }
    }
}

@propertyWrapper
struct UserDefaultPrimitive<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults = UserDefaults.standard
    
    init(key: PreferenceKey, default: T) {
        self.key = key.rawValue
        self.defaultValue = `default`
    }
    
    var wrappedValue: T {
        get { (userDefaults.object(forKey: key) as? T) ?? defaultValue }
        set { userDefaults.set(newValue, forKey: key) }
    }
}
