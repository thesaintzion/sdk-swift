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
    
    func getPreAuthenticationInfo(params: DJParameters, completion: @escaping DJResultAction<DJPreAuthResponse>) {
        service.makeRequest(
            responseType: DJPreAuthResponse.self,
            requestMethod: .get,
            remotePath: .preAuth,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
    
    func authenticate(params: DJParameters, completion: @escaping DJResultAction<DJAuthResponse>) {
        service.makeRequest(
            responseType: DJAuthResponse.self,
            requestMethod: .post,
            remotePath: .auth,
            parameters: params,
            headers: ["Authorization": UUID().uuidString],
            completion: completion
        )
    }
    
    func getIPAddress(completion: @escaping DJResultAction<DJIPAddress>) {
        service.makeRequest(
            responseType: DJIPAddress.self,
            requestMethod: .get,
            remotePath: .ipCheck,
            parameters: nil,
            headers: nil,
            completion: completion
        )
    }
    
    func saveIPAddress(params: DJParameters, completion: @escaping DJResultAction<DJIPAddressResponse>) {
        service.makeRequest(
            responseType: DJIPAddressResponse.self,
            requestMethod: .post,
            remotePath: .saveIP,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
}
