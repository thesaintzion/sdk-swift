//
//  URLSession+.swift
//
//
//  Created by Isaac Iniongun on 05/12/2023.
//

import Foundation

extension URLSession {
    static func withTimeout(_ timeout: TimeInterval) -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout // Timeout interval in seconds
        return URLSession(configuration: config)
    }
}
