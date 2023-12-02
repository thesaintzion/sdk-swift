//
//  NetworkService.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func makeRequest<T: Codable>(
        responseType: T.Type,
        requestMethod: DJHttpMethod,
        remotePath: DJRemotePath,
        parameters: Parameters?,
        headers: HeaderParameters?,
        completion: @escaping DJResultAction<T>
    ) {
        
        guard var urlComponents = URLComponents(string: remotePath.absolutePath) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if let parameters, requestMethod == .get {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }
        
        guard let requestURL = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        kprint("Request URL: \(requestURL.absoluteURL)")
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = requestMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if requestMethod == .post, let parameters {
            do {
                let requestBody = try parameters.serializedData()
                urlRequest.httpBody = requestBody
            } catch {
                completion(.failure(.encodingFailure(reason: error.localizedDescription)))
            }
        }
        
        if let headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let httpURLResponse = urlResponse as? HTTPURLResponse {
                let statusCode = httpURLResponse.statusCode
                
                if (400...499).contains(statusCode) {
                    completion(.failure(.resourceNotFound))
                }
                
                if statusCode >= 500 {
                    completion(.failure(.serverFailure))
                }
                
                return
            }
            
            if let error {
                completion(.failure(.requestFailure(reason: error.localizedDescription)))
                return
            }
            
            if let data {
                do {
                    let response = try data.decode(into: T.self)
                    kprint("Request Response:")
                    kprint(response.prettyJson)
                    completion(.success(response))
                } catch {
                    completion(.failure(.decodingFailure(reason: error.localizedDescription)))
                }
                
                return
            } else {
                completion(.failure(.noResponseData))
            }
            
        }.resume()
    }
}
