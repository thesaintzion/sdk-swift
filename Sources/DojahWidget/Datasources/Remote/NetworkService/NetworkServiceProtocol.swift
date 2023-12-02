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
        parameters: Parameters?,
        headers: HeaderParameters?,
        completion: @escaping DJResultAction<T>
    )
}
