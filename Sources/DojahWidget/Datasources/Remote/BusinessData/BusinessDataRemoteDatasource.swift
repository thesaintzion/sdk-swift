//
//  BusinessDataRemoteDatasource.swift
//
//
//  Created by Isaac Iniongun on 13/02/2024.
//

import Foundation

struct BusinessDataRemoteDatasource: BusinessDataRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func verify(
        type: BusinessDataType,
        params: DJParameters,
        completion: @escaping DJResultAction<EntityResponse<BusinessDataResponse>>
    ) {
        service.makeRequest(
            responseType: EntityResponse<BusinessDataResponse>.self,
            requestMethod: .get,
            remotePath: type.remotePath,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
}
