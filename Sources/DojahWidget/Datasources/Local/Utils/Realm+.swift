//
//  Realm+.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation
import RealmSwift

extension Realm {
    func save<T: Object>(items: [T], updatePolicy: UpdatePolicy = .modified) throws {
        try write {
            add(items, update: updatePolicy)
        }
    }
    
    func getItems<T: Object>() -> [T] {
        Array(objects(T.self))
    }
    
    func get<T: Object, KeyType>(pk: KeyType) -> T? {
        object(ofType: T.self, forPrimaryKey: pk)
    }
}
