//
//  Encodable+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation

func jsonData(from fileName: String) -> Data? {
    guard let jsonURL = DojahBundle.bundle.url(forResource: fileName, withExtension: "json") else {
        print("unable to load json")
        return nil
    }
    return try? Data(contentsOf: jsonURL)
}

extension Decodable {
    ///Maps JSON String to actual Decodable Object
    ///throws an exception if mapping fails
    static func mapFrom(jsonString: String) throws -> Self? {
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Self.self, from: Data(jsonString.utf8))
    }
}

extension Encodable {
    var jsonString: String {
        do {
            return String(data: try JSONEncoder().encode(self), encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    
    var prettyJson: String {
        if let responseData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) {
            return String(data: responseData, encoding: .utf8) ?? ""
        }
        return ""
    }
    
    var dictionaryValue: Any {
        do {
            let data = try JSONEncoder().encode(self)
            //return String(data: data , encoding: .utf8) ?? ""
            return try JSONSerialization.jsonObject(with: data)
        } catch {
            return ""
        }
    }
    
    var dictionaryArray: [[String: Any]] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [[String: Any]] ?? [[:]]
    }
    
    func encodedData() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
}

extension Data {
    func decode<T: Decodable>(into objectType: T.Type) throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }
    
    func decode<T: Codable>(into objectType: T.Type) throws -> T {
        try JSONDecoder().decode(objectType.self, from: self)
    }
    
    func prettyJson() throws -> String {
        let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
        let prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
        
        return String(data: prettyJsonData, encoding: .utf8) ?? "--unable--to--get--prettyJson--"
    }
}

extension Dictionary {
    var prettyJson: String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) {
            return String(data: jsonData, encoding: .ascii) ?? ""
        }
        return ""
    }
    
    func serializedData() throws -> Data {
        try JSONSerialization.data(withJSONObject: self, options: [])
    }
}
