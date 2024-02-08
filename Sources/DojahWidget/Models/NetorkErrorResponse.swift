//
//  NetorkErrorResponse.swift
//
//
//  Created by Isaac Iniongun on 08/02/2024.
//

import Foundation

// MARK: - ErrorResponse
struct NetorkErrorResponse: Codable {
    let error: NetworkError?
}

// MARK: - Error
struct NetworkError: Codable {
    let message: String?
    let code: Int?
    let success: Bool?
}
