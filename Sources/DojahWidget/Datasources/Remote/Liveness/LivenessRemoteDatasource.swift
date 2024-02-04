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
    
    func performImageAnalysis(
        params: DJParameters,
        completion: @escaping DJResultAction<EntityResponse<ImageAnalysisResponse>>
    ) {
        service.makeRequest(
            responseType: EntityResponse<ImageAnalysisResponse>.self,
            requestMethod: .post,
            remotePath: .imageAnalysis,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
    
    func performImageCheck(
        params: DJParameters,
        completion: @escaping DJResultAction<EntityResponse<ImageCheckResponse>>
    ) {
        service.makeRequest(
            responseType: EntityResponse<ImageCheckResponse>.self,
            requestMethod: .post,
            remotePath: .imageCheck,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
    
    func verifyImage(
        params: DJParameters,
        completion: @escaping DJResultAction<EntityResponse<ImageVerificationResponse>>
    ) {
        service.makeRequest(
            responseType: EntityResponse<ImageVerificationResponse>.self,
            requestMethod: .post,
            remotePath: .verifyImage,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
    
    func uploadDocument(
        params: DJParameters,
        completion: @escaping DJResultAction<SuccessEntityResponse>
    ) {
        service.makeRequest(
            responseType: SuccessEntityResponse.self,
            requestMethod: .post,
            remotePath: .files,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
}
