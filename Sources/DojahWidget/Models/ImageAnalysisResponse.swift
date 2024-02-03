//
//  ImageAnalysisResponse.swift
//
//
//  Created by Isaac Iniongun on 30/01/2024.
//

import Foundation

struct ImageAnalysisResponse: Codable {
    let face: ImageAnalysisFace?
    let id: ImageAnalysisID?
}

struct ImageAnalysisFace: Codable {
    let faceDetected: Bool?
    let message: String?
    let multifaceDetected: Bool?
    let details: ImageAnalysisFaceDetails?
    let quality: FaceQuality?
    let confidence: Double?
    let boundingBox: AnalysisBoundingBox?

    enum CodingKeys: String, CodingKey {
        case faceDetected = "face_detected"
        case message
        case multifaceDetected = "multiface_detected"
        case details, quality, confidence
        case boundingBox = "bounding_box"
    }
}

struct AnalysisBoundingBox: Codable {
    let width, height, boundingBoxLeft, top: Double?

    enum CodingKeys: String, CodingKey {
        case width, height
        case boundingBoxLeft = "left"
        case top
    }
}
