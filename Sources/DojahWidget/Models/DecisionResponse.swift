//
//  DecisionResponse.swift
//
//
//  Created by Isaac Iniongun on 08/02/2024.
//

import Foundation

struct DecisionResponse: Codable {
    let status: DecisionStatus?
    let reason: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "overallCheck"
        case reason
    }
    
    var feedbackType: FeedbackType {
        status?.feedbackType ?? .warning
    }
}

enum DecisionStatus: String, Codable {
    case approved, pending, failed
    
    var feedbackType: FeedbackType {
        switch self {
        case .approved:
            return .success
        case .pending:
            return .warning
        case .failed:
            return .failure
        }
    }
    
    var feedbackMessage: String {
        switch self {
        case .approved:
            return "Your identification has been successfully verified."
        case .pending:
            return "Your identification process is awaiting approval."
        case .failed:
            return "Your identification cannot be verified."
        }
    }
    
    var feedbackTitle: String {
        switch self {
        case .approved:
            return "Verification successful"
        case .pending:
            return "Verification awaiting approval"
        case .failed:
            return "Verification failed"
        }
    }
}
