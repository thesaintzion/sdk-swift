//
//  LivenessRemoteDatasource.swift
//
//
//  Created by Isaac Iniongun on 25/01/2024.
//

import Foundation

struct LivenessRemoteDatasource: LivenessRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
}
