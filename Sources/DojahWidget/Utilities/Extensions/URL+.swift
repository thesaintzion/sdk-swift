//
//  URL+.swift
//
//
//  Created by Isaac Iniongun on 05/02/2024.
//

import Foundation

extension URL {
    var localFileData: Data? {
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            kprint("Error reading the local file data: \(error)")
            return nil
        }
    }
}
