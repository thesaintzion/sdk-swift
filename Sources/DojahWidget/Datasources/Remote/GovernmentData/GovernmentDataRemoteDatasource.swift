//
//  GovernmentDataRemoteDatasource.swift
//
//
//  Created by Isaac Iniongun on 12/12/2023.
//

import Foundation

struct GovernmentDataRemoteDatasource: GovernmentDataRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
}
