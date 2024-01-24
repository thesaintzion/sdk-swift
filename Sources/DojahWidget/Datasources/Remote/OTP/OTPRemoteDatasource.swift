//
//  OTPRemoteDatasource.swift
//
//
//  Created by Isaac Iniongun on 13/12/2023.
//

import Foundation

struct OTPRemoteDatasource: OTPRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
}
