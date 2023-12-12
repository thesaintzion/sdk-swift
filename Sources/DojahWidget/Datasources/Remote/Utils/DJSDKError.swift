//
//  DJSDKError.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation

enum DJSDKError: Error, Equatable {
    case invalidURL
    case requestFailure(reason: String)
    case decodingFailure(reason: String)
    case encodingFailure(reason: String)
    case resourceNotFound
    case serverFailure
    case unableToLoadLocalJSON
    case noResponseData
    case tryAgain
    
    var description: String? {
        switch self {
        case .invalidURL:
            return "Bad Request URL"
        case .requestFailure(reason: let reason):
            return "Unable to perform request, please try again.\nReason: \(reason)"
        case .decodingFailure(reason: let reason):
            return "Unable to read data from server, please try again.\nReason: \(reason)"
        case .encodingFailure(reason: let reason):
            return "Unable to send request data, please try again.\nReason: \(reason)"
        case .resourceNotFound:
            return "Unable to locate resource on the server, please try again or contact customer support."
        case .serverFailure:
            return "Unable to contact the server, please try again."
        case .unableToLoadLocalJSON:
            return "Unable to load local JSON file."
        case .noResponseData:
            return "No response data returned for network request."
        case .tryAgain:
            return "Please try that again."
        }
    }
}
