//
//  UserDataRemoteDatasource.swift
//
//
//  Created by Isaac Iniongun on 25/01/2024.
//

import Foundation

struct UserDataRemoteDatasource: UserDataRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func saveUserData(params: DJParameters, completion: @escaping DJResultAction<SuccessEntityResponse>) {
        service.makeRequest(
            responseType: SuccessEntityResponse.self,
            requestMethod: .post,
            remotePath: .userData,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
}
