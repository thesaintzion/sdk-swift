//
//  withFunc+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation

@discardableResult 
func with<T>(_ it: T, f:(T) -> ()) -> T {
    f(it)
    return it
}
