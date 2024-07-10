//
//  DJRequestHeaders.swift
//
//
//  Created by Isaac Iniongun on 07/12/2023.
//

import Foundation

struct DJRequestHeaders: Codable {
    let authorization: String
    let appID: String
    let publicKey: String
    let sessionID: String
    let referenceID: String
    
    init(
        authorization: String = UUID().uuidString,
        appID: String,
        publicKey: String,
        sessionID: String,
        referenceID: String
    ) {
        self.authorization = authorization
        self.appID = appID
        self.publicKey = publicKey
        self.sessionID = sessionID
        self.referenceID = referenceID
    }
    
    enum CodingKeys: String, CodingKey {
        case authorization
        case appID = "app-id"
        case publicKey = "p-key"
        case sessionID = "session"
        case referenceID = "reference"
    }
}
