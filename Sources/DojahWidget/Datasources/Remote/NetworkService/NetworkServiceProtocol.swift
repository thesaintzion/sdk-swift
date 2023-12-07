//
//  NetworkServiceProtocol.swift
//  
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func makeRequest<T: Codable>(
        responseType: T.Type,
        requestMethod: DJHttpMethod,
        remotePath: DJRemotePath,
        parameters: DJParameters?,
        headers: DJHeaderParameters?,
        completion: @escaping DJResultAction<T>
    )
}
