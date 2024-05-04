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
    case lowBalance
    case networkError(String)
    case invalidOTPEntered
    case OTPCouldNotBeSent
    case invalidIDNotFoundThirdParty
    case invalidIDThirdPartyFailure
    case invalidIDNotFoundThirdPartyMessage(DJGovernmentIDType)
    case invalidIDNotFoundGovernmentData(DJGovernmentIDType)
    case invalidIDNotFoundBusinessData(BusinessDataType)
    case selfieVideoCouldNotBeCaptured
    case govtIDCouldNotBeCaptured
    case imageCheckOrAnalysisError
    case countryNotSupported
    case verificationCompleted
    
    var uiMessage: String {
        switch self {
        //TODO: This code might be useful later
        /*case .invalidURL:
            return "Bad Request URL"
        case let .networkError(reason):
            return reason
        case .requestFailure(reason: let reason):
            return "Unable to perform request, please try again.\nReason: \(reason)"
        case .decodingFailure(reason: let reason):
            return "Unable to read data from server, please try again.\nReason: \(reason)"
        case .encodingFailure(reason: let reason):
            return "Unable to send request data, please try again.\nReason: \(reason)"*/
        case .invalidURL, .resourceNotFound, .serverFailure, .tryAgain, .lowBalance, .noResponseData, .requestFailure, .decodingFailure, .encodingFailure, .networkError:
            return "An error occured. Try again later"
        case .unableToLoadLocalJSON:
            return "Unable to load local JSON file."
        case .invalidOTPEntered:
            return "Invalid OTP entered. Please, input the correct OTP"
        case .OTPCouldNotBeSent:
            return "OTP Could not be sent, Please try again"
        case .invalidIDNotFoundThirdParty:
            return "invalidIDNotFound"
        case let .invalidIDNotFoundThirdPartyMessage(idType):
            return "\(idType.rawValue) is currently not available. Please try another means of identification"
        case let .invalidIDNotFoundGovernmentData(idType):
            return "Invalid \(idType.rawValue). Input a valid \(idType.rawValue) or try another means of Identification"
        case let .invalidIDNotFoundBusinessData(idType):
            return "Invalid \(idType.rawValue). Input a valid \(idType.rawValue) or try another means of Identification"
        case .selfieVideoCouldNotBeCaptured:
            return "Please move to a well lit environment and try again"
        case .govtIDCouldNotBeCaptured:
            return "Document is not clear enough, please try again"
        case .imageCheckOrAnalysisError:
            return "imageCheckOrAnalysisError"
        case .invalidIDThirdPartyFailure:
            return "invalidIDThirdPartyFailure"
        case .countryNotSupported:
            return "Widget is not supported in your country"
        case .verificationCompleted:
            return "verificationCompleted"
        }
    }
}
