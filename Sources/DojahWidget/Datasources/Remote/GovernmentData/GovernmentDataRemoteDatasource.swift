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
    
    func lookupID(number: String, idType: DJGovernmentIDType, completion: @escaping DJResultAction<EntityResponse<GovernmentDataLookupEntity>>) {
        service.makeRequest(
            responseType: EntityResponse<GovernmentDataLookupEntity>.self,
            requestMethod: .get,
            remotePath: idType.remotePath,
            parameters: [idType.lookupParameterKeyName: number],
            headers: nil,
            completion: completion
        )
    }
}
