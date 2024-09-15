//
//  AnalysisFaceDetails.swift
//
//
//  Created by Isaac Iniongun on 30/01/2024.
//

import Foundation

struct ImageAnalysisFaceDetails: Codable {
    let ageRange: FaceAgeRange?
    let smile: FaceDetailBoolean?
    let gender: FaceDetailString?
    let eyeglasses, sunglasses, beard, mustache: FaceDetailBoolean?
    let eyesOpen, mouthOpen: FaceDetailBoolean?
    let emotions: [FaceDetailEmotion]?

    enum CodingKeys: String, CodingKey {
        case ageRange = "age_range"
        case smile, gender, eyeglasses, sunglasses, beard, mustache
        case eyesOpen = "eyes_open"
        case mouthOpen = "mouth_open"
        case emotions
    }
}

// MARK: - AgeRange
struct FaceAgeRange: Codable {
    let low, high: Int?
}

// MARK: - Beard
struct FaceDetailBoolean: Codable {
    let value: Bool?
    let confidence: Double?
}

// MARK: - Emotion
struct FaceDetailEmotion: Codable {
    let type: String?
    let confidence: Double?
}

// MARK: - Gender
struct FaceDetailString: Codable {
    let value: String?
    let confidence: Double?
}

// MARK: - Quality
struct FaceQuality: Codable {
    let brightness, sharpness: Double?
}
