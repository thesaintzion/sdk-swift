//
//  File.swift
//  
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

struct DJPreAuthResponse: Codable {
    let widget: DJWidget?
    let publicKey: String?
    let appConfig: DJAppConfig?
    let reviewProcess: String?

    enum CodingKeys: String, CodingKey {
        case widget
        case publicKey = "public_key"
        case appConfig = "app"
        case reviewProcess = "review_process"
    }
}
