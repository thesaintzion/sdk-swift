//
//  AuthenticationRemoteDatasource.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

struct AuthenticationRemoteDatasource: AuthenticationRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func getPreAuthenticationInfo(params: Parameters, completion: @escaping DJResultAction<DJPreAuthResponse>) {
        service.makeRequest(
            responseType: DJPreAuthResponse.self,
            requestMethod: .get,
            remotePath: .preAuth,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
}
