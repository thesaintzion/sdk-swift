//
//  Data+.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation

func jsonData(from fileName: String) -> Data? {
    guard let jsonURL = Bundle.module.url(forResource: fileName, withExtension: "json") else {
        print("unable to load json")
        return nil
    }
    return try? Data(contentsOf: jsonURL)
}

extension Data {
    func decode<T: Codable>(into objectType: T.Type) throws -> T? {
        try JSONDecoder().decode(objectType.self, from: self)
    }
}
