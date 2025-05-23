//
//  MetaDataRemoteDatasource.swift
//
//  Created by AbdulMujeeb on 22/05/2025.
//

struct MetaDataRemoteDatasource: MetaDataRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func sendMetaData(params: DJParameters, completion: @escaping DJResultAction<SuccessEntityResponse>) {
        service.makeRequest(
            responseType: SuccessEntityResponse.self,
            requestMethod: .post,
            remotePath: .metadata,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
}
