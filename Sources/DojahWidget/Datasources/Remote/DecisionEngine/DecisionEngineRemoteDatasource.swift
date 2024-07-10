//
//  DecisionEngineRemoteDatasource.swift
//  
//
//  Created by Isaac Iniongun on 08/02/2024.
//

import Foundation

struct DecisionEngineRemoteDatasource: DecisionEngineRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func makeVerificationDecision(completion: @escaping DJResultAction<EntityResponse<DecisionResponse>>) {
        service.makeRequest(
            responseType: EntityResponse<DecisionResponse>.self,
            requestMethod: .get,
            remotePath: .decision,
            parameters: nil,
            headers: nil,
            completion: completion
        )
    }
}
