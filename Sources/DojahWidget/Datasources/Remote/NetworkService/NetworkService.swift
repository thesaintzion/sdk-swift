//
//  NetworkService.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
    private let preference: PreferenceProtocol
    
    init(
        urlSession: URLSession = URLSession.withTimeout(60),
        preference: PreferenceProtocol = PreferenceImpl()
    ) {
        self.urlSession = urlSession
        self.preference = preference
    }
    
    func makeRequest<T: Codable>(
        responseType: T.Type,
        requestMethod: DJHttpMethod,
        remotePath: DJRemotePath,
        parameters: DJParameters?,
        headers: DJHeaderParameters?,
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
        
        if remotePath == .cac {
            urlComponents.queryItems?.append(.init(name: "app_id", value: preference.DJRequestHeaders["app-id"] ?? ""))
        }
        
        if remotePath == .decision {
            let params: DJParameters = [
                "verification_id": preference.DJVerificationID,
                "session_id": preference.DJRequestHeaders["session"] ?? ""
            ]
            
            urlComponents.queryItems = params.map { key, value in
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
        
        if requestMethod == .post, var parameters {
            do {
                if [.events, .saveIP, .userData, .imageCheck, .verifyImage, .files].contains(remotePath) {
                    parameters = parameters.merge(["verification_id": preference.DJVerificationID])
                }
                
                if [.events, .imageCheck].contains(remotePath) {
                    parameters = parameters.merge(["step_number": preference.DJAuthStep.id ?? 0])
                }
                
                if remotePath == .events {
                    parameters = parameters.merge([
                        "session_id": preference.DJRequestHeaders["session"] ?? "",
                        "app_id": preference.DJRequestHeaders["app-id"] ?? "",
                        "cost": 0
                    ])
                }
                
                let requestBody = try parameters.serializedData()
                urlRequest.httpBody = requestBody
                
                kprint("\(remotePath.path) Request Body:")
                kprint(parameters.prettyJson)
                
            } catch {
                completion(.failure(.encodingFailure(reason: error.localizedDescription)))
            }
        }
        
        if let headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if ![.preAuth, .auth].contains(remotePath), preference.DJRequestHeaders.isNotEmpty {
            for (key, value) in preference.DJRequestHeaders {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let requestHeaders = urlRequest.allHTTPHeaderFields {
            kprint("Request Headers:")
            kprint(requestHeaders.prettyJson)
        }
        
        urlSession.dataTask(with: urlRequest) { [weak self] data, urlResponse, error in
            self?.printDataResponse(data, path: remotePath)
            
            if let networkError = try? data?.decode(into: NetorkErrorResponse.self).error {
                completion(.failure(.networkError(networkError.message ?? DJConstants.genericErrorMessage)))
                return
            }
            
            if let httpURLResponse = urlResponse as? HTTPURLResponse {
                let statusCode = httpURLResponse.statusCode
                
                kprint("Status Code: \(statusCode)")
                kprint("Error: \(String(describing: error))")
                
                if (400...499).contains(statusCode) {
                    if statusCode == 402 && remotePath == .auth {
                        completion(.failure(.verificationCompleted))
                        return
                    }
                    
                    if statusCode == 402 {
                        completion(.failure(.lowBalance))
                        return
                    }
                    
                    let isGovtIDLookup = [.bvnLookup, .ninLookup, .driversLicenseLookup, .vninLookup, .tin].contains(remotePath)
                    if statusCode == 424 {
                        completion(.failure(isGovtIDLookup ? .invalidIDThirdPartyFailure : .serverFailure))
                        return
                    }
                    
                    if [404, 400].contains(statusCode) && isGovtIDLookup {
                        completion(.failure(.invalidIDNotFoundThirdParty))
                        return
                    }
                    
                    completion(.failure(.resourceNotFound))
                    return
                }
                
                if statusCode >= 500 {
                    kprint("500: Network Error:")
                    kprint("\(String(describing: error))")
                    completion(.failure(.serverFailure))
                    return
                }
                
                if statusCode != 200 {
                    if [.imageCheck, .imageAnalysis].contains(remotePath) {
                        completion(.failure(.imageCheckOrAnalysisError))
                    }
                    if remotePath == .files {
                        completion(.failure(.govtIDCouldNotBeCaptured))
                    }
                    return
                }
            }
            
            if let error {
                kprint("Network Error:")
                kprint("\(error)")
                completion(.failure(.requestFailure(reason: error.localizedDescription)))
                return
            }
            
            if let data {
                
                if let networkError = try? data.decode(into: NetorkErrorResponse.self).error {
                    if networkError.code == 402 && remotePath == .auth {
                        completion(.failure(.verificationCompleted))
                    } else {
                        completion(.failure(.networkError(networkError.message ?? DJConstants.genericErrorMessage)))
                    }
                    return
                }
                
                do {
                    let response = try data.decode(into: T.self)
                    kprint("\(remotePath.path) Codable Request Response:")
                    kprint(response.prettyJson)
                    completion(.success(response))
                } catch {
                    kprint("Decoding Error:")
                    kprint("\(error)")
                    completion(.failure(.decodingFailure(reason: error.localizedDescription)))
                }
            } else {
                kprint("No Response Data:")
                completion(.failure(.noResponseData))
            }
            
        }.resume()
    }
    
    private func printDataResponse(_ data: Data?, path: DJRemotePath) {
        if let data {
            do {
                kprint("\(path.path) Request Data Response:")
                kprint(try data.prettyJson())
            } catch {
                kprint("Unable to read data response as JSON for \(path.path)")
            }
        }
    }
}
