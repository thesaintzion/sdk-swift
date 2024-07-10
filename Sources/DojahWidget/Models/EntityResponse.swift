//
//  EntityResponse.swift
//  
//
//  Created by Isaac Iniongun on 13/12/2023.
//

import Foundation

struct EntityResponse<T: Codable>: Codable {
    let entity: T?
}
