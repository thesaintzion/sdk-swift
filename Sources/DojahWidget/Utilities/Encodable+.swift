//
//  Encodable+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation

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
    
    var prettyPrinted: String {
        let responseData = try! JSONSerialization.data(withJSONObject: self.dictionary, options: .prettyPrinted)
        return String(data: responseData, encoding: .utf8)!
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
    
}
